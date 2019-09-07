/*main will use a veb tree method with the Gillespie Algorithm to model the mutation of genes and proteins in a population of dividing cells*/
package main

import (
	"bytes"
	"encoding/csv"
	"flag"
	"fmt"
	"generation/Code/save"
	"generation/Code/synthData/lineage"
	"generation/Code/synthData/mutation"
	"log"
	"math"
	"math/rand"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"runtime/debug"
	"runtime/pprof"
	"strconv"
	"strings"
	"sync"
	"time"
)

const (
	maxT float64 = 75 * 365
	/*----------------------------------------------------------------------
	                Lineage Const and Vars found in lineage/variables.go
	------------------------------------------------------------------------*/
	initCellNo int = 100 // Initial number of wt cells
)

/*----------------------------------------------------------------------
                Flags from command line
------------------------------------------------------------------------*/
var (
	rdir = flag.String("rdir", "test", "Directory to save results")
	gdir = flag.String("gdir", "test", "Genome to Load")
	r    = flag.Int64("r", time.Now().Unix(), "A random number seed")

	wtcycle    = flag.Float64("wv", 0.1, "Wild type cell cycle rate")
	ccycle     = flag.Float64("cv", 0.4, "Cancer cell cycle rate")
	wtdeath    = flag.Float64("wd", 0.034, "Wild type death rate")
	cdeath     = flag.Float64("cd", 0.017, "Cancer death rate")
	mutrate    = flag.Float64("m", 1, "BP mutations per 100,000,000 bp")
	repfail    = flag.Float64("f", 1, "Fraction of mutations that don't get repaired")
	ko2        = flag.Float64("wk", 1e-6, "Wild type oxygen consumption")
	minko2     = flag.Float64("ck", 0.7e-6, "Cancer oxygen consumption")
	kec50      = flag.Float64("k", 2.5, "Cancer threshold")
	tend       = flag.Float64("t", 5, "Years to run simulation")
	cellBiop   = flag.Int("b", 500, "Cells to biopsy")
	genomeSnp  = flag.Float64("snp", 1.0, "% natural snps already in gene")
	split      = flag.Float64("s", 10, "How many pieces to split the data into for bam sorting")
	cpuprofile = flag.String("cpuprofile", "", "write cpu profile to `file`")
	memprofile = flag.String("memprofile", "", "write memory profile to `file`")
	/*----------------------------------------------------------------------
	                VEB Const
	------------------------------------------------------------------------*/
	nB   = flag.Int("nb", 2e7, "Number of Veb Bins. Max is 2**32-1") //int(math.Pow(2, 32)) - 1 //Number of time bins
	tT   float64                                                     // tree cycle time
	bT   float64                                                     // Time span of each bin
	tEnd float64
)

var (
	/*----------------------------------------------------------------------
	                Event Vars
	------------------------------------------------------------------------*/
	t         float64                  // Current simulation time
	qT        float64                  // Number of full cycles completed  []bool
	cSlice    []*[]*lineage.CellStruct // Map from bin location to struct of cells
	cCache    []*[]*lineage.CellStruct
	freeCells = make([]*lineage.CellStruct, 0, 100000)
	/*----------------------------------------------------------------------
	                Save Vars
	------------------------------------------------------------------------*/
	overwrite        bool = true
	cellTot          int
	oncScore         float64
	tsgScore         float64 // 2 elements first one is added second one is subtracted
	seed             int
	saveFileChan     = make(chan interface{})
	saveFileChanGene = make(chan interface{})
	saveVarsChan     = make(chan interface{})
	saveClose        = make(chan int)
	saveVarsClose    = make(chan int)
	saveGeneClose    = make(chan int)
	done             = make(chan int)
	doneVars         = make(chan int)
	doneGene         = make(chan int)
	wg               sync.WaitGroup
	saveStruct       = struct {
		T        *float64
		Cells    *int
		OncScore *float64
		TsgScore *float64
	}{&t, &cellTot, &oncScore, &tsgScore}
	saveVars = struct {
		Seed    *int
		WtCycle *float64
		CCycle  *float64
		WtDeath *float64
		CDeath  *float64
		MutRate *float64
		GeneSnp *float64
		RepFail *float64
		VO2     *float64
		RO2     *float64
		KO2     *float64
		MinKO2  *float64
		Kec50   *float64
		MaxO2   *float64
		CritO2  *float64
		NecrO2  *float64
	}{&seed, &lineage.WtCycle, &lineage.CCycle, &lineage.WtDeath, &lineage.CDeath, &lineage.MutRate, &mutation.GeneSnp, &lineage.RepFail, &lineage.VO2, &lineage.RO2, &lineage.KO2, &lineage.MinKO2, &lineage.Kec50, &lineage.MaxO2, &lineage.CritO2, &lineage.NecrO2}

	savePrivateGene struct {
		Seq *string
	}
	savePrivateGeneH struct {
		GeneNo *string
	}
)

func main() {
	/*----------------------------------------------------------------------
	                Flags from command line
	------------------------------------------------------------------------*/
	flag.Parse()

	if *cpuprofile != "" {
		f, err := os.Create(*cpuprofile)
		if err != nil {
			log.Fatal("could not create CPU profile: ", err)
		}
		if err := pprof.StartCPUProfile(f); err != nil {
			log.Fatal("could not start CPU profile: ", err)
		}
		defer pprof.StopCPUProfile()
	}
	tT = 1.1 * maxT // tree cycle time
	bT = tT / float64(*nB)
	tEnd = *tend * 365
	cSlice = make([]*[]*lineage.CellStruct, *nB)
	cCache = make([]*[]*lineage.CellStruct, 0, *nB/100)
	lineage.WtCycle = *wtcycle
	lineage.CCycle = *ccycle
	lineage.WtDeath = *wtdeath
	lineage.CDeath = *cdeath
	lineage.MutRate = *mutrate
	lineage.RepFail = *repfail
	lineage.KO2 = *ko2
	lineage.MinKO2 = *minko2
	lineage.Kec50 = *kec50
	mutation.GeneSnp = *genomeSnp

	/*----------------------------------------------------------------------
	                Seed Random Number Generator and Start Clock
	------------------------------------------------------------------------*/
	start := time.Now()
	seed = int(*r)
	rand.Seed(*r)

	/*----------------------------------------------------------------------
	                Initialize Genome
	------------------------------------------------------------------------*/
	//Create the genome in genomes/createGenome.go
	mypath, err := filepath.Abs(".")
	warning(err)
	genomeFile := filepath.Join(mypath, "genome", *gdir, "genome.fasta")
	oncFile := filepath.Join(mypath, "genome", *gdir, "oncDriver.fasta")
	tsgFile := filepath.Join(mypath, "genome", *gdir, "tsgDriver.fasta")
	varFile := filepath.Join(mypath, "genome", *gdir, "variables.csv")
	mutation.LoadGenome(genomeFile, oncFile, tsgFile, varFile)
	pMutation := 0.0
	for _, v := range mutation.RefGene {
		pMutation += float64(len(v))
	}
	pMutation = lineage.MutRate * pMutation / 100000000 // per-hundred million of genome mutated at each division
	pRepFail := lineage.RepFail
	/*----------------------------------------------------------------------
	                Initialize Cells
	------------------------------------------------------------------------*/

	cellTot = initCellNo
	for i := 0; i < initCellNo; i++ {
		cell := lineage.CellStruct{}
		initialize(t, &cell, cellTot, &oncScore, &tsgScore)
	}

	t1 := time.Since(start)
	fmt.Printf("Initialized tree and added %v cells in %v \n", initCellNo, t1)

	/*----------------------------------------------------------------------
	                Create Files and Save Headers and Variables
	------------------------------------------------------------------------*/
	folder := filepath.Join(mypath, "result", *gdir, *rdir)
	err = os.MkdirAll(folder, os.ModePerm)
	warning(err)
	file0 := filepath.Join(folder, "dynamics")
	file1 := filepath.Join(folder, "variables")
	file2 := filepath.Join(folder, "cells")
	file3 := filepath.Join(folder, "genes")
	file4 := filepath.Join(folder, "DriverGenes.csv")
	if overwrite {
		os.Remove(file0 + ".csv")
		os.Remove(file1 + ".csv")
		os.Remove(file2 + "_Normal.fa")
		os.Remove(file2 + "_Cancer.fa")
		os.Remove(file3 + ".fa")
		os.Remove(file4)
	}

	// Saving the headers for the save files
	save.SaveHeader(file1, ".csv", saveVars)   // Var Header
	save.SaveHeader(file0, ".csv", saveStruct) // Data Header

	// Initial save
	go save.SaveFile(file0, ".csv", saveFileChan, saveClose, done) // Data Values
	wg.Add(1)
	go func() {
		saveFileChan <- saveStruct
		<-done
		wg.Done()
	}()

	go save.SaveFile(file1, ".csv", saveVarsChan, saveVarsClose, doneVars) // Data Values
	wg.Add(1)
	go func() {
		saveVarsChan <- saveVars
		<-doneVars
		wg.Done()
	}()
	wg.Wait()

	go save.SaveFile(file3, ".fa", saveFileChanGene, saveGeneClose, doneGene) // Data Values
	wg.Add(1)
	go func() {
		for i, v := range mutation.RefGene {
			geneNo := ">" + strconv.Itoa(i)
			savePrivateGeneH.GeneNo = &geneNo
			saveFileChanGene <- savePrivateGeneH
			<-doneGene
			savePrivateGene.Seq = &v
			saveFileChanGene <- savePrivateGene
			<-doneGene
		}
		wg.Done()
	}()
	saveGeneClose <- 0
	wg.Wait()
	saveCounter := 0
	saveCounterAdd := 200
	/*======================================================================
	                SSA Algorithm Time Evolution
	========================================================================*/
	// Next event bin key
	wg.Add(1)
	go func() {
	Loop:
		for key := range cSlice {
			if cSlice[key] == nil { //struct empty
				continue
			}
			// Sort by which event in bin occurs first
			ind := sortBin(key)
			// if events scheduled for this time frame
			for (*cSlice[key])[ind].EventTime < tT*(qT+1) {
				// execute event: Add or delete cells as necessary, add time
				cell := (*cSlice[key])[ind]
				t = cell.EventTime

				switch cell.Event {
				case 0: // Apoptosis
					freeCells = append(freeCells, cell)
					lineage.Apoptosis(key, ind, cSlice, &oncScore, &tsgScore)
					cellTot += -1

				case 1: // Division
					m, o := lineage.Division(key, ind, cSlice, &oncScore, &tsgScore, &freeCells)
					mutation.MutateCell(&o.GeneMut.G, &o.GeneMut.Pos, &o.GeneMut.Nuc, o.OncEffect, o.TsgEffect, pMutation, pRepFail)
					mutation.MutateCell(&m.GeneMut.G, &m.GeneMut.Pos, &m.GeneMut.Nuc, m.OncEffect, m.TsgEffect, pMutation, pRepFail)

					// temp += oncScore[0]
					initialize(t, o, cellTot, &oncScore, &tsgScore)
					initialize(t, m, cellTot, &oncScore, &tsgScore)

					cellTot += 1
				}

				// Saving
				if int(t) > saveCounter || t > tEnd {
					// oncScore, tsgScore = cancerScore(cMap, cellTot)
					saveFileChan <- saveStruct
					<-done
					saveCounter += saveCounterAdd
					if t > tEnd {
						break Loop
					}
				}

				// Checking if bin is empty
				if len(*cSlice[key]) < 1 {
					cCache = append(cCache, cSlice[key])
					cSlice[key] = nil
					break
					if cellTot == 0 {
						fmt.Println("All Cells Dead")
						break Loop
					}
				}
				// Next item in bin
				ind = sortBin(key)
				if (tsgScore+oncScore)/float64(cellTot) > lineage.Kec50 {
					saveFileChan <- saveStruct
					<-done
					break Loop
				}
			}
			// If cancerous end simulation

		}
		if *memprofile != "" {
			f, err := os.Create(*memprofile)
			if err != nil {
				log.Fatal("could not create memory profile: ", err)
			}
			runtime.GC() // get up-to-date statistics
			if err := pprof.WriteHeapProfile(f); err != nil {
				log.Fatal("could not write memory profile: ", err)
			}
			f.Close()
		}
		wg.Done()
	}()
	saveClose <- 0
	saveVarsClose <- 0
	wg.Wait()
	t2 := time.Since(start) - t1
	fmt.Printf("Run complete in %v\n", t2)
	cCache = nil
	freeCells = nil
	cellRead(file2, file4)
	fmt.Printf("Reads Saved in %v\n", time.Since(start)-t2)

}

/*----------------------------------------------------------------------
                FUNCTIONS
------------------------------------------------------------------------*/

// sortBin sorts the events found in a bin
func sortBin(key int) int {
	cells := cSlice[key]
	ind := 0
	for i := 1; i < len(*cells); i++ {
		if (*cells)[i].EventTime < (*cells)[ind].EventTime {
			ind = i
		}
	}
	return ind
}

// initialize initializes a cell and adds it to the queue
func initialize(t float64, cell *lineage.CellStruct, cellTot int, oncscore, tsgscore *float64) {

	// onc := 0.0
	for _, val := range cell.OncEffect {
		(*oncscore) += val
	}
	// tsg := 0.0
	for _, val := range cell.TsgEffect {
		(*tsgscore) += val
	}

	rng := []float64{rand.Float64(), rand.Float64()}
	et, e := lineage.Gillespie(rng, cell, cellTot, *oncscore, *tsgscore)
	bn := getBin(et + t)
	addCell(bn, e, et+t, cell)

}

//getBin finds the corresponding bin number for an event time
func getBin(et float64) (bn int) {
	ti := math.Mod(et, tT)
	bn = int(ti / bT)
	return
}

// addCell adds a cell and its properties to the map
func addCell(bn, e int, et float64, cell *lineage.CellStruct) {
	if cell.OncEffect == nil {
		cell.OncEffect = make([]float64, len(mutation.OncGene))
		cell.TsgEffect = make([]float64, len(mutation.TsgGene))
	}
	cell.EventTime = et
	cell.Event = e
	if cSlice[bn] == nil {
		if len(cCache) == 0 {
			a := make([]*lineage.CellStruct, 0)
			cSlice[bn] = &a
		} else {
			cSlice[bn] = cCache[0]
			cCache = cCache[1:]
		}
	}
	*cSlice[bn] = append(*cSlice[bn], cell)
}

func inArray(a []int, val int) bool {
	for _, v := range a {
		if v == val {
			return true
		}
	}
	return false
}

// CellRead creates a fasta file with all cell reads
func cellRead(filename, drivergeneFile string) {

	var (
		normalWrite []byte
		cancerWrite []byte
		wg          sync.WaitGroup
		cellNormal  int
		cellCancer  int
		sampleSize  int = *cellBiop
		cancerArray     = make([]*lineage.CellStruct, sampleSize)
		normalArray     = make([]*lineage.CellStruct, sampleSize)
	)
	normalFile := filename + "_Normal" // Data Values
	cancerFile := filename + "_Cancer" // Data Values
	tsgCause := []int{}
	oncCause := []int{}
	for _, r := range rand.Perm(len(cSlice)) {
		v := cSlice[r]
		if v == nil {
			continue
		}
		for i, v2 := range *v {
			ponc := []int{}
			ptsg := []int{}
			cancer := 0.0
			for ind, c := range v2.OncEffect {
				if c > 0 {
					ponc = append(ponc, mutation.OncGene[ind])
				}
				cancer += c
			}
			for ind, c := range v2.TsgEffect {
				if c > 0 {
					ptsg = append(ptsg, mutation.TsgGene[ind])
				}
				cancer += c
			}
			if cancer > lineage.Kec50 && cellCancer < sampleSize {
				for _, val := range ponc {
					if !inArray(oncCause, val) {
						oncCause = append(oncCause, val)
					}
				}
				for _, val := range ptsg {
					if !inArray(tsgCause, val) {
						tsgCause = append(tsgCause, val)
					}
				}
				cancerArray[cellCancer] = v2
				cellCancer++

			} else if cancer <= lineage.Kec50 && cellNormal < sampleSize {

				normalArray[cellNormal] = v2
				cellNormal++

			} else if cellNormal >= sampleSize && cellCancer >= sampleSize {
				(*cSlice[r])[i] = nil
			}
		}
	}
	wlength := len(oncCause)
	var oncCauseString []string
	var tsgCauseString []string
	if len(tsgCause) > wlength {
		oncCauseString = make([]string, len(tsgCause))
		tsgCauseString = make([]string, len(tsgCause))
		for i := range oncCause {
			oncCauseString[i] = strconv.Itoa(oncCause[i])
			tsgCauseString[i] = strconv.Itoa(tsgCause[i])
		}
		for i := wlength; i < len(tsgCause); i++ {
			tsgCauseString[i] = strconv.Itoa(tsgCause[i])

		}

		wlength = len(tsgCause)
	} else {
		oncCauseString = make([]string, wlength)
		tsgCauseString = make([]string, wlength)
		for i := range tsgCause {
			oncCauseString[i] = strconv.Itoa(oncCause[i])
			tsgCauseString[i] = strconv.Itoa(tsgCause[i])
		}
		for i := len(tsgCause); i < wlength; i++ {
			oncCauseString[i] = strconv.Itoa(oncCause[i])

		}

	}

	f, err := os.Create(drivergeneFile)
	warning(err)
	w := csv.NewWriter(f)
	w.Write([]string{"TSG", "ONC"})
	for record := 0; record < wlength; record++ {
		err := w.Write([]string{tsgCauseString[record], oncCauseString[record]})
		warning(err)
	}
	w.Flush()
	f.Close()

	depth := 3
	debug.FreeOSMemory()
	cnt := float64(1)
	mod := float64(mutation.GeneNo / *split)
	iter := 0

	for i, genes := range mutation.RefGene {

		for c := 0; c < sampleSize; c++ {
			cc := cancerArray[c]
			tmpgene := []byte(genes)
			if cc != nil {
				for index, g := range cc.GeneMut.G {
					if int(g) == i {
						tmpgene[cc.GeneMut.Pos[index]] = cc.GeneMut.Nuc[index]
					}
				}

				cellNo := strconv.Itoa(c)
				geneNo := strconv.Itoa(i)
				dcnt := 0
				l := len(tmpgene)
				for d := 0; d < depth; d++ {
					loc := 0
					for loc < l {
						tmpheader := []byte("@" + cellNo + ":" + geneNo + "-" + strconv.Itoa(dcnt) + "\n")
						if loc+499 < l {
							reads := fastq(tmpgene[loc : 499+loc])
							cancerWrite = append(cancerWrite, append(tmpheader, reads...)...)
						} else {
							reads := fastq(tmpgene[l-499:])
							cancerWrite = append(cancerWrite, append(tmpheader, reads...)...)
						}
						loc += 499
						dcnt++
					}
				}
			}
			cn := normalArray[c]
			tmpgene = []byte(genes)
			if cn != nil {
				for index, g := range cn.GeneMut.G {
					if int(g) == i {
						tmpgene[cn.GeneMut.Pos[index]] = cn.GeneMut.Nuc[index]
					}
				}
				cellNo := strconv.Itoa(c)
				geneNo := strconv.Itoa(i)
				dcnt := 0
				l := len(tmpgene)
				for d := 0; d < depth; d++ {
					loc := 0
					for loc < l {
						tmpheader := []byte("@" + cellNo + ":" + geneNo + "-" + strconv.Itoa(dcnt) + "\n")
						if loc+499 < l {
							reads := fastq(tmpgene[loc : 499+loc])
							normalWrite = append(normalWrite, append(tmpheader, reads...)...)
						} else {
							reads := fastq(tmpgene[l-499:])
							normalWrite = append(normalWrite, append(tmpheader, reads...)...)
						}
						loc += 499
						dcnt++
					}
				}
			}
		}

		if math.Mod(cnt, mod) == 0 {
			// err := ioutil.WriteFile(cancerFile+".fq", cancerWrite, 0644)
			// warning(err)
			mkfifo(normalFile + ".fq")
			// mkfifo(normalFile + ".sam")
			mkfifo(normalFile + ".bam")
			mkfifo(cancerFile + ".fq")
			// mkfifo(cancerFile + ".sam")
			mkfifo(cancerFile + ".bam")
			wg.Add(5)
			go func() {
				nfile, err := os.OpenFile(normalFile+".fq", os.O_RDWR, os.ModeNamedPipe)
				warning(err)
				nfile.Write(normalWrite)
				nfile.Close()
				wg.Done()
			}()
			go func() {
				cfile, err := os.OpenFile(cancerFile+".fq", os.O_RDWR, os.ModeNamedPipe)
				warning(err)
				cfile.Write(cancerWrite)
				cfile.Close()
				wg.Done()
			}()
			go func() {
				star(cancerFile)
				wg.Done()
			}()
			go func() {
				star(normalFile)
				wg.Done()
			}()

			// go func() {
			// 	samtools(cancerFile)
			// 	wg.Done()
			// }()
			// go func() {
			// 	samtools(normalFile)
			// 	wg.Done()
			// }()

			go func() {
				somaticSniper(filename, cancerFile+".bam", normalFile+".bam", strconv.Itoa(iter))
				wg.Done()
			}()
			wg.Wait()
			os.Remove(normalFile + ".fq")
			os.Remove(normalFile + ".sam")
			os.Remove(normalFile + ".bam")
			os.Remove(cancerFile + ".fq")
			os.Remove(cancerFile + ".sam")
			os.Remove(cancerFile + ".bam")
			cancerWrite = []byte{}
			normalWrite = []byte{}
			iter++
		}
		cnt++
	}

}
func mkfifo(filename string) {
	pipe := exec.Command("mkfifo", filename)
	var out, stderr bytes.Buffer
	err := pipe.Run()
	pipe.Stdout = &out
	pipe.Stderr = &stderr
	if err != nil {
		fmt.Println("Error is:\n", stderr.String(), out.String())
		warning(err)
	}
}

func fastq(seq []byte) []byte {
	error := 0.003
	read := make([]byte, len(seq))
	quality := make([]byte, len(seq))
	for i, _ := range quality {
		quality[i] = 'z'
	}
	copy(read, seq)
	mutation.MutateSeq(read, quality, error)
	read = append(read, '\n', '+', '\n')
	quality = append(quality, '\n')

	return append(read, quality...)
}

func bwa(filename string) {
	mypath, err := filepath.Abs(".")
	warning(err)
	genomeFile := filepath.Join(mypath, "genome", *gdir, "genome.fasta")

	bwaCmd := exec.Command("bwa", "mem", "-t", "2", genomeFile, filename+".fq")
	file, err := os.OpenFile(filename+".sam", os.O_RDWR, os.ModeNamedPipe)
	warning(err)
	file.Write([]byte("@HD VN:1.6\tSO:coordinate\n"))
	file.Close()
	output(bwaCmd, filename+".sam")
}

func star(filename string) {
	mypath, err := filepath.Abs(".")
	warning(err)
	genomeDir := filepath.Join(mypath, "genome", *gdir)
	starCmd := exec.Command("STAR",
		"--genomeDir", genomeDir, "--readFilesIn", filename+".fq",
		"--outFileNamePrefix", filename,
		"--outStd", "BAM_Unsorted",
		"--outSAMtype", "BAM", "Unsorted",
		"--outSAMheaderHD", string("@HD VN:1.6\tSO:coordinate"))

	output(starCmd, filename+".bam")

}

func samtools(filename string) {
	samCmd := exec.Command("samtools", "view", "-hu", "-@", "2", filename+".sam")
	output(samCmd, filename+".bam")

}

func somaticSniper(filename, cancerFile, normalFile, iter string) {
	mypath, err := filepath.Abs(".")
	warning(err)
	genomeFile := filepath.Join(mypath, "genome", *gdir, "genome.fasta")

	iter = leftPad2Len(iter, "0", 3)
	sniperCmd := exec.Command("bam-somaticsniper", "-G", "-L", "-F", "vcf",
		"-f", genomeFile, cancerFile, normalFile, filename+"_"+iter+".vcf")

	var errout bytes.Buffer
	sniperCmd.Stderr = &errout
	err = sniperCmd.Run()
	if err != nil {
		fmt.Println("Error is:\n", errout.String())
		warning(err)
	}

}

func output(cmd *exec.Cmd, filename string) []byte {
	var out, errout bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &errout
	err := cmd.Run()
	if err != nil {
		fmt.Println("Error is:\n", errout.String())
		warning(err)
	}

	file, err := os.OpenFile(filename, os.O_RDWR, os.ModeNamedPipe)
	warning(err)
	file.Write(out.Bytes())
	file.Close()
	return out.Bytes()
}

func leftPad2Len(s string, padStr string, overallLen int) string {
	var padCountInt int
	padCountInt = 1 + ((overallLen - len(padStr)) / len(padStr))
	var retStr = strings.Repeat(padStr, padCountInt) + s
	return retStr[(len(retStr) - overallLen):]
}

// warning
func warning(err error) {
	if err != nil {
		panic(err)
	}
}

func illumina(filename, cellFile string) {
	rs := strconv.Itoa(rand.Int())
	illuminaCmd := exec.Command("art_illumina",
		"-i", cellFile+".fa", "-o", filename,
		"-ss", "MSv3", "-l", "250", "-c", "15", "-k", "0", "-na", "-q", "-rs", rs)

	err := illuminaCmd.Run()
	warning(err)
}
