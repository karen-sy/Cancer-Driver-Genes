// Mutation will keep track of and model the DNA and proteins in each cell
// There will be 2 sets per gene and translation and transcription will be treated as 1
// Drivers and Deleterious Passengers will be pre determined
package mutation

import (
	"bytes"
	"encoding/csv"
	"io"
	"math"
	"math/rand"
	"os"
	"strconv"
	"strings"
)

func init() {
	initiateCodon()
}

//Load in genome //called from main.go
func LoadGenome(filename, oncFile, tsgFile, varFile string) {
	genef, err := os.Open(filename)
	warning(err)
	defer genef.Close()

	r := csv.NewReader(genef)
	r.FieldsPerRecord = -1
	r.Comma = '\t'

	for { //refgene
		data, err := r.Read()
		if err == io.EOF {
			break
		}
		warning(err)
		data, err = r.Read()
		if err == io.EOF {
			break
		}
		RefGene = append(RefGene, data...)
	}

	tsgf, err := os.Open(tsgFile)
	warning(err)
	defer tsgf.Close()

	r = csv.NewReader(tsgf)
	r.FieldsPerRecord = -1
	r.Comma = '\t'
	for { //tsg
		data, err := r.Read()
		if err == io.EOF {
			break
		}
		warning(err)
		num, err := strconv.Atoi(data[0][1:])
		warning(err)

		TsgGene = append(TsgGene, num)
	}

	oncf, err := os.Open(oncFile)
	warning(err)
	defer oncf.Close()
	r = csv.NewReader(oncf)
	r.FieldsPerRecord = -1
	r.Comma = '\t'

	for { //oncogene
		data, err := r.Read()
		if err == io.EOF {
			break
		}
		warning(err)
		num, err := strconv.Atoi(data[0][1:])
		warning(err)
		data, err = r.Read()
		data = data[:len(data)-1]
		if err == io.EOF {
			break
		}
		OncMap[num] = data
		OncGene = append(OncGene, num)
	}
	///////// Var File
	varf, err := os.Open(varFile)
	warning(err)
	defer varf.Close()
	r = csv.NewReader(varf)
	r.FieldsPerRecord = -1
	r.Comma = ','

	data, err := r.Read()
	warning(err)
	data2, err := r.Read()
	warning(err)
	oncLoc := 0 // Variable list location of OncStrength
	tsgLoc := 0 // Variable list location of TsgStrength
	warning(err)
	for i, v := range data {
		if v == "OncStrength" {
			oncLoc = i
			continue
		}
		if v == "TsgStrength" {
			tsgLoc = i
			continue
		}
		switch v {
		case "GeneNo":
			GeneNo, err = strconv.ParseFloat(data2[i], 64)
		case "GeneLen":
			GeneLen, err = strconv.ParseFloat(data2[i], 64)
		case "GeneStd":
			GeneStd, err = strconv.ParseFloat(data2[i], 64)
		case "DriverFrac":
			DriverFrac, err = strconv.ParseFloat(data2[i], 64)
		case "OncFrac":
			OncFrac, err = strconv.ParseFloat(data2[i], 64)
		}
		warning(err)
	}
	r1 := csv.NewReader(strings.NewReader(data2[oncLoc]))
	r1.Comma = ':'

	for {
		d, err := r1.Read()
		if err == io.EOF {
			break
		}
		warning(err)
		i, err := strconv.Atoi(d[0])
		warning(err)
		v, err := strconv.ParseFloat(d[1], 64)
		warning(err)
		OncStrength[i] = v
	}

	r1 = csv.NewReader(strings.NewReader(data2[tsgLoc]))
	r1.Comma = ':'

	for {
		d, err := r1.Read()
		if err == io.EOF {
			break
		}
		warning(err)
		i, err := strconv.Atoi(d[0])
		warning(err)
		v, err := strconv.ParseFloat(d[1], 64)
		warning(err)
		TsgStrength[i] = v
	}
	geneWeights()
	genomeVariation() // Vary the genome by some percentage
}

//called from above func
func genomeVariation() {
	// This is a percent so divide by 100
	snps := float64(GeneLen*GeneNo) * GeneSnp / 100
	n := int(rand.NormFloat64()*snps/4 + snps)
	geneLoc, mutLoc := mutLocation(n)
	i := 0
	for i < n {
		if len(mutLoc) == 0 {
			continue
		}

		m := mutLoc[i]
		g := geneLoc[i]
		if m > 2 && m < (len(RefGene[g])-3) { // No mutations at M or *
			mutNucleotide := mutateNucleotide(string(RefGene[g][m]))
			temp := RefGene[g][0:m] + string(mutNucleotide) + RefGene[g][m+1:]
			whichCancer := false         // 0 for non cancer gene 1 for TSG gene 2 for ONC
			for _, tg := range TsgGene { // Check if mutation occurs at TSG and is stop codon
				if tg == g {
					cod := findCodon([]byte(temp[m/3 : m/3+3]))
					if cod == "*" {
						whichCancer = true
					}

				}
			}

			for _, loc := range OncMap[g] { // Check if mutation occurs at onc point
				r := csv.NewReader(strings.NewReader(loc))
				r.Comma = ':'
				d, _ := r.Read()
				pos := m / 3                  // This needs to be the mutated nuc position
				dPos, _ := strconv.Atoi(d[1]) // position where onc mutation occurs
				if pos == dPos {
					whichCancer = true
				}
			}

			if !whichCancer {
				RefGene[g] = temp
				i++
				continue
			}
		}
		j := 0
		for j < 1 {
			newg, newm := mutLocation(1)
			if len(newg) > 0 {
				geneLoc[i] = newg[0]
				mutLoc[i] = newm[0]
				j++
			}

		}
	}
}

// Create WildType genome //called from createGenome.go
func CreateGenome() {
	for i := 0.0; i < GeneNo; i++ { // Loop over total number of genes
		length := 0.0
		for length < 6 { // Length must be at least so that I can have a start and stop codon
			length = math.Floor((rand.NormFloat64()*GeneStd+GeneLen)/3) * 3 // Must be multiple of 3
		}

		s := "ATG" //Start codon
		c := ""
		for len(s) < int(length)-3 { // len-3 to ensure stop codon
			switch rand.Intn(4) { //Add nucleotides randomly
			case 0:
				c += "T"
			case 1:
				c += "C"
			case 2:
				c += "G"
			case 3:
				c += "A"
			}
			if len(c) == 3 {
				c0 := translate(c[0])
				c1 := translate(c[1])
				c2 := translate(c[2])
				aa := codonMap[c0][c1][c2]
				if aa == '*' { //Ensure no stop codon is in the middle of a seq
					c = ""
					continue
				}
				s += c // Add codon to sequence
				c = ""
			}
		}
		switch rand.Intn(3) { //Add random stop codon at end of seq
		case 0:
			s += "TGA"
		case 1:
			s += "TAA"
		case 2:
			s += "TAG"
		}
		RefGene = append(RefGene, s) // Add sequence to genome
	}

	selectDrivers() //Initiate driver selection
}

// Select Drivers (OG and TSG); called from above func
func selectDrivers() {
	driverNum := DriverFrac * GeneNo                       // total number of drivers
	oncNum := int(math.Ceil(driverNum * OncFrac))          // Fraction oncogenes
	tsgNum := int(math.Floor(driverNum * (1.0 - OncFrac))) // Fraction TSGs
	//Permute genes to select random onco and tsg's and ensure no repeats
	genePerm := rand.Perm(int(GeneNo))

	// Create tsg's by tagging which ones cannot have stop codon
	for i := 0; i < tsgNum; i++ {
		TsgGene = append(TsgGene, genePerm[i]) //Create TSG gene list
		TsgStrength[genePerm[i]] = 1           //rand.Float64() //Stength of each TSG mutstion btwn 0-1
	}

	for i := tsgNum; i < tsgNum+oncNum; i++ { //Create OG's
		var oncSites []string         // String of oncogenic sites for map
		oncSiteNo := rand.Intn(2) + 1 //How many mutation sites on a gene will be OG mutations

		seq := RefGene[genePerm[i]] // Seq for oncogene
		p := findCodon([]byte(seq)) // Protein for oncogene
		site := rand.Perm(len(p))   //Select an onco amino acid mutation site and ensure no repeats
		for j := 0; j < oncSiteNo; j++ {
			// Create oncosite splice where first letter is normal gene, second number is aa location, final can be a specific aa it must be turned in to to become onco gene
			oncSites = append(oncSites, string(p[site[j]])+":"+strconv.Itoa(site[j])+":"+"X")
		}
		OncMap[genePerm[i]] = oncSites // Create Oncogenes map
		OncStrength[genePerm[i]] = 1   //rand.Float64() //Stength of each OG mutstion btwn 0-1
	}
}

// Mutate will mutate the genome of the cell
// called from main.go (SSA evolution)
// Note: Maybe make this a CellStruct Method
func MutateCell(GeneMutG, GeneMutP *[]uint16, GeneMutN *[]byte, OncEffect, TsgEffect []float64, MutRate, RepFail float64) {
	n := poisson(MutRate)
	if n == 0 {
		return
	}
	geneLoc, mutLoc := mutLocation(n)

	for j, loc := range mutLoc { // k is which gene, loc is where on the gene
		k := geneLoc[j]
		tK := 0
		oK := 0
		whichCancer := 0 // 0 for non cancer gene 1 for TSG gene 2 for ONC
		for i, g := range TsgGene {
			if k == g {
				tK = i
				whichCancer = 1
			}
		}
		if whichCancer == 0 {
			if len(OncMap[k]) > 0 {
				for i, g := range OncGene {
					if k == g {
						oK = i
						whichCancer = 2
					}
				}
			}
		}

		gene := []byte(RefGene[k])
		index := -1
		for i := 0; i < len(*GeneMutG); i++ {
			if int((*GeneMutG)[i]) == k {
				gene[(*GeneMutP)[i]] = (*GeneMutN)[i]
				if int((*GeneMutP)[i]) == loc {
					index = i
				}
			}
		}
		nucContext := nucleotideContext(gene, loc)
		mutNucleotide := mutateNucleotide(nucContext)
		gene[loc] = mutNucleotide
		p := findCodon(gene)
		oldTsgEffect := TsgEffect[tK]
		oldOncEffect := OncEffect[oK]
		// Check if TsgGene
		if whichCancer == 1 {
			TsgEffect[tK] = 0                            // set to 0 to ensure can be mutated back
			v2 := p[loc/3]                               // location of mutation
			if string(v2) == "*" && loc/3 < (len(p)-1) { //Make sure mutaion is stop codon not at the end
				bool := repair(GeneMutG, GeneMutP, GeneMutN, .25, index, k, loc, mutNucleotide)
				if bool {
					TsgEffect[tK] = TsgStrength[k]
					// sum := 0.0
					// og := []int{}
					// for i, v := range TsgEffect {
					// 	sum += v
					// 	if v != 0 {
					// 		og = append(og, TsgGene[i])
					// 	}
					// }
					// if sum > 1.5 {
					// 	fmt.Println("Tsg:", og)
					// }
				} else {
					TsgEffect[tK] = oldTsgEffect
				}

			} else {

				bool := repair(GeneMutG, GeneMutP, GeneMutN, RepFail, index, k, loc, mutNucleotide)
				if bool {
					for i := 0; i < len(p)-1; i++ {
						if string(p[i]) == "*" {
							TsgEffect[tK] = TsgStrength[k]

						}
					}
				} else {
					TsgEffect[tK] = oldTsgEffect
				}

			}

		} else if whichCancer == 2 {
			OncEffect[oK] = 0
			oncTrue := false
			for _, g := range OncMap[k] {
				r := csv.NewReader(strings.NewReader(g))
				r.Comma = ':'
				d, _ := r.Read()
				pos := loc / 3                // This needs to be the mutated nuc position
				dPos, _ := strconv.Atoi(d[1]) // position where onc mutation occurs
				if pos == dPos {
					// Check if codon changed and is not a tsg type mutation
					if string(p[pos]) != d[0] && string(p[pos]) != "*" {
						// codon change can be anything or it changed to something specific
						if d[2] == "X" || string(p[pos]) == d[2] {
							OncEffect[oK] = OncStrength[k]
							oncTrue = true
							break
						}
					}
				}
				// Ensure old mutaion still exists
				if string(p[dPos]) != d[0] && string(p[pos]) != "*" {
					if d[2] == "X" || string(p[dPos]) == d[2] {
						OncEffect[oK] = OncStrength[k]
					}
				}
			}

			if oncTrue {
				repair(GeneMutG, GeneMutP, GeneMutN, 1, index, k, loc, mutNucleotide)

			} else {
				bool := repair(GeneMutG, GeneMutP, GeneMutN, RepFail, index, k, loc, mutNucleotide)
				if !bool {
					OncEffect[oK] = oldOncEffect
				}
			}

		} else {
			repair(GeneMutG, GeneMutP, GeneMutN, RepFail, index, k, loc, mutNucleotide)
		}

		// Mutate if it fails to repair
		// if isCancer == 0 {
		// 	r := rand.Float64()
		// 	if r < RepFail {
		// 		if index < 0 {
		// 			*GeneMutG = append(*GeneMutG, uint16(k))
		// 			*GeneMutP = append(*GeneMutP, uint16(loc))
		// 			*GeneMutN = append(*GeneMutN, mutNucleotide)
		// 		} else {
		// 			(*GeneMutN)[index] = mutNucleotide
		// 		}
		// 	}
		// }
	}
}

//called from above func
func repair(GeneMutG, GeneMutP *[]uint16, GeneMutN *[]byte, rp float64, index, k, loc int, mutNucleotide byte) bool {
	r := rand.Float64()
	if r < rp {
		if index < 0 {
			*GeneMutG = append(*GeneMutG, uint16(k))
			*GeneMutP = append(*GeneMutP, uint16(loc))
			*GeneMutN = append(*GeneMutN, mutNucleotide)
		} else {
			(*GeneMutN)[index] = mutNucleotide
		}
		return true // Gene mutated
	}

	return false // Gene did not mutate
}

//MutateSeq: see mutateNucleotide //called from main.go/fastq,cellRead
func MutateSeq(seq, quality []byte, error float64) {
	l := len(seq)
	n := poisson(error * float64(l))
	if n == 0 {
		return
	}
	loc := make([]int, n)
	copy(loc, rand.Perm(l))
	for _, v := range loc {
		nucContext := nucleotideContext(seq, v)
		mutNucleotide := mutateNucleotide(nucContext)
		seq[v] = mutNucleotide
		quality[v] = '!'

	}

}

// mutLocation Selects random gene and random nucleotide per mutation number according to mutRate //called from above MutateSeq, genomeVariation, MutateCell (funcs that need to set location)
func mutLocation(n int) (geneLoc []int, mutLoc []int) {
	geneLoc = make([]int, n)
	mutLoc = make([]int, n)
	// If more than 1 new location iterate through to find locations g at nucleotides loc. Ensure that the same gene cannot have more than 1 mutation at each nucleotide
	for i := 0; i < n; i++ {
		g := weightedChoice()
		if g < 0 {
			panic("Weighted Choices Broken")
		}
		loc := 0
		for same := 1; same > 0; {
			loc = rand.Intn(len(RefGene[g]))
			for j, v := range geneLoc {
				if mutLoc[j] == loc && v == g {
					same++
					break
				}
			}
			same--
		}
		geneLoc[i] = g
		mutLoc[i] = loc
	}

	return
}

// nucleotideContext will find the nucleotide context //called from func MutateSeq, MutateCell
func nucleotideContext(s []byte, loc int) string {
	var sm1 byte
	var sp1 byte

	if loc > 0 {
		sm1 = s[loc-1]
	}

	if loc < (len(s) - 1) {
		sp1 = s[loc+1]
	}

	switch s[loc] {
	case 'C':
		if sp1 == 'G' {
			return "C*pG"
		} else if sm1 == 'T' {
			return "TpC*"
		}

	case 'G':
		if sm1 == 'C' {
			return "CpG*"
		} else if sp1 == 'A' {
			return "G*pA"
		}
	}
	return string(s[loc])
}

// mutateNucleotide will change the selected nucleotide and mutate it according to mutMap //called from MutateSeq
func mutateNucleotide(context string) byte {
	r := rand.Float64()
	p := 0.0
	for i, v := range mutMap[context] {
		p += v
		if p > r {
			switch i {
			case 0:
				return 'T'
			case 1:
				return 'C'
			case 2:
				return 'G'
			case 3:
				return 'A'

			}
			break
		}

	}
	return 'A'
}

// Find codon according to codonMap
func findCodon(s []byte) string {
	var b bytes.Buffer
	for i := 0; i < len(s); i += 3 {
		c0 := translate(s[i])
		c1 := translate(s[i+1])
		c2 := translate(s[i+2])

		b.WriteByte(codonMap[c0][c1][c2])
	}
	return b.String()
}

//called from findCodon
func translate(a byte) int {
	switch a {
	case 'T':
		return 0
	case 'C':
		return 1
	case 'G':
		return 2
	}
	return 3

}

// Poisson Number generator //Called from MutateCell, MutateSeq
func poisson(lam float64) int {
	x := 0.0
	p, s := math.Exp(-lam), math.Exp(-lam)
	u := rand.Float64()
	for u > s {
		x++
		p *= lam / x
		s += p
	}
	return int(x)
}

func geneWeights() {
	geneweight = make([]int, len(RefGene))

	for i, v := range RefGene {
		geneweight[i] = len(v)
		genesum += len(v)
	}

}

//called from mutLocation
func weightedChoice() int {
	r := rand.Intn(genesum)
	for i, c := range geneweight {
		r -= c
		if r < 0 {
			return i
		}
	}

	return -1
}

// warning
func warning(err error) {
	if err != nil {
		panic(err)
	}
}

// Select deleterious passangers (Not now)

// What happens if mutated? This might be in the cell lineage file
func initiateCodon() {
	// T=0, C=1, G=2, A=3
	codonMap[0][0][0] = 'F'
	codonMap[0][0][1] = 'F'
	codonMap[0][0][3] = 'L'
	codonMap[0][0][2] = 'L'
	codonMap[1][0][0] = 'L'
	codonMap[1][0][1] = 'L'
	codonMap[1][0][3] = 'L'
	codonMap[1][0][2] = 'L'
	codonMap[3][0][0] = 'I'
	codonMap[3][0][1] = 'I'
	codonMap[3][0][3] = 'I'
	codonMap[3][0][2] = 'M'
	codonMap[2][0][0] = 'V'
	codonMap[2][0][1] = 'V'
	codonMap[2][0][3] = 'V'
	codonMap[2][0][2] = 'V'
	codonMap[0][1][0] = 'S'
	codonMap[0][1][1] = 'S'
	codonMap[0][1][3] = 'S'
	codonMap[0][1][2] = 'S'
	codonMap[1][1][0] = 'P'
	codonMap[1][1][1] = 'P'
	codonMap[1][1][3] = 'P'
	codonMap[1][1][2] = 'P'
	codonMap[3][1][0] = 'T'
	codonMap[3][1][1] = 'T'
	codonMap[3][1][3] = 'T'
	codonMap[3][1][2] = 'T'
	codonMap[2][1][0] = 'A'
	codonMap[2][1][1] = 'A'
	codonMap[2][1][3] = 'A'
	codonMap[2][1][2] = 'A'
	codonMap[0][3][0] = 'Y'
	codonMap[0][3][1] = 'Y'
	codonMap[0][3][3] = '*'
	codonMap[0][3][2] = '*'
	codonMap[1][3][0] = 'H'
	codonMap[1][3][1] = 'H'
	codonMap[1][3][3] = 'Q'
	codonMap[1][3][2] = 'Q'
	codonMap[3][3][0] = 'N'
	codonMap[3][3][1] = 'N'
	codonMap[3][3][3] = 'K'
	codonMap[3][3][2] = 'K'
	codonMap[2][3][0] = 'D'
	codonMap[2][3][1] = 'D'
	codonMap[2][3][3] = 'E'
	codonMap[2][3][2] = 'E'
	codonMap[0][2][0] = 'C'
	codonMap[0][2][1] = 'C'
	codonMap[0][2][3] = '*'
	codonMap[0][2][2] = 'W'
	codonMap[1][2][0] = 'R'
	codonMap[1][2][1] = 'R'
	codonMap[1][2][3] = 'R'
	codonMap[1][2][2] = 'R'
	codonMap[3][2][0] = 'S'
	codonMap[3][2][1] = 'S'
	codonMap[3][2][3] = 'R'
	codonMap[3][2][2] = 'R'
	codonMap[2][2][0] = 'G'
	codonMap[2][2][1] = 'G'
	codonMap[2][2][3] = 'G'
	codonMap[2][2][2] = 'G'

}
