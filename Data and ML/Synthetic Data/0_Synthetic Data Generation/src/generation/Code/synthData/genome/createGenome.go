package main

import (
	"flag"
	"generation/Code/save"
	"generation/Code/synthData/mutation"
	"math/rand"
	"os"
	"path/filepath"
	"strconv"
	"sync"
	"time"
)

var (
	oncStrength   string
	tsgStrength   string
	seed          int
	done          = make(chan int)
	saveFileChan0 = make(chan interface{}) //genes
	saveFileChan1 = make(chan interface{}) //oncogenes
	saveFileChan2 = make(chan interface{}) //tumor suppressors
	saveFileChan3 = make(chan interface{})

	saveGenomeHeader struct {
		GeneNo *string
	}
	saveGenomeSeq struct {
		Seq *string
	}
	saveVars = struct {
		Seed        *int
		GeneNo      *float64
		GeneLen     *float64
		GeneStd     *float64
		DriverFrac  *float64
		OncFrac     *float64
		OncStrength *string
		TsgStrength *string
	}{&seed, &mutation.GeneNo, &mutation.GeneLen, &mutation.GeneStd, &mutation.DriverFrac, &mutation.OncFrac, &oncStrength, &tsgStrength}

	saveClose = make(chan int)
)

func main() {
	r := flag.Int64("r", time.Now().Unix(), "A random number seed, otherwise time")
	dir := flag.String("dir", "test", "Directory to save results")
	GeneNo := flag.Float64("gn", 200, "Number of Genes")
	GeneLen := flag.Float64("gl", 1000, "Mean Length of Genes")
	GeneStd := flag.Float64("gs", 100, "Standard Deviation of Length of Gene")
	DriverFrac := flag.Float64("df", 0.1, "Fraction of Genes that are Drivers")
	OncFrac := flag.Float64("of", 0.5, "Fraction of Genes that are Oncogenes")
	flag.Parse()

	mutation.GeneNo = *GeneNo
	mutation.GeneLen = *GeneLen
	mutation.GeneStd = *GeneStd
	mutation.DriverFrac = *DriverFrac
	mutation.OncFrac = *OncFrac

	seed = int(*r)
	rand.Seed(*r)
	mypath := filepath.Join(".", *dir)
	err := os.MkdirAll(mypath, os.ModePerm)
	if err != nil {
		panic(err)
	}
	file0 := filepath.Join(mypath, "genome")
	file1 := filepath.Join(mypath, "oncDriver")
	file2 := filepath.Join(mypath, "tsgDriver")
	file3 := filepath.Join(mypath, "variables")
	format := ".fasta"

	os.Remove(file0 + format)
	os.Remove(file1 + format)
	os.Remove(file2 + format)
	os.Remove(file3 + ".csv")
	var wg sync.WaitGroup
	mutation.CreateGenome()

	go save.SaveFile(file0, format, saveFileChan0, saveClose, done) // Data Values
	wg.Add(1)
	go func() {
		for i, v := range mutation.RefGene { //for every wildtype ('refgene') gene
			geneNo := ">" + strconv.Itoa(i) //(itoa: integer to str)
			saveGenomeHeader.GeneNo = &geneNo
			saveFileChan0 <- saveGenomeHeader
			<-done
			saveGenomeSeq.Seq = &v
			saveFileChan0 <- saveGenomeSeq
			<-done
		}
		wg.Done()
	}()
	saveClose <- 0
	wg.Wait()

	go save.SaveFile(file1, format, saveFileChan1, saveClose, done) // Data Values
	wg.Add(1)
	go func() {
		for k, v := range mutation.OncMap { //for every oncogene
			geneNo := ">" + strconv.Itoa(k)
			saveGenomeHeader.GeneNo = &geneNo
			saveFileChan1 <- saveGenomeHeader
			<-done
			var muts string
			for _, v2 := range v {
				muts += v2 + "\t"
			}
			saveGenomeSeq.Seq = &muts
			saveFileChan1 <- saveGenomeSeq
			<-done
		}
		wg.Done()
	}()
	saveClose <- 0
	wg.Wait()

	go save.SaveFile(file2, format, saveFileChan2, saveClose, done) // Data Values
	wg.Add(1)
	go func() {
		for _, v := range mutation.TsgGene { //for every tsg
			geneNo := ">" + strconv.Itoa(v)
			saveGenomeHeader.GeneNo = &geneNo
			saveFileChan2 <- saveGenomeHeader
			<-done
		}
		wg.Done()
	}()
	saveClose <- 0
	wg.Wait()

	for k, v := range mutation.TsgStrength {
		tsgStrength += strconv.Itoa(k) + ":" + strconv.FormatFloat(v, 'E', -1, 64) + "\n"
	}
	for k, v := range mutation.OncStrength {
		oncStrength += strconv.Itoa(k) + ":" + strconv.FormatFloat(v, 'E', -1, 64) + "\n"
	}
	tsgStrength = tsgStrength[:len(tsgStrength)-1]
	oncStrength = oncStrength[:len(oncStrength)-1]
	save.SaveHeader(file3, ".csv", saveVars)
	go save.SaveFile(file3, ".csv", saveFileChan3, saveClose, done)
	wg.Add(1)
	go func() {
		saveFileChan3 <- saveVars
		<-done
		wg.Done()
	}()
	saveClose <- 0
	wg.Wait()

}
