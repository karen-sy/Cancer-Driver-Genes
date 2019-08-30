package mutation

// Wild Type Genome Vars

var (
	GeneNo     float64  // Number of Genes
	GeneLen    float64  // Mean gene length (is divisible by 3)
	GeneStd    float64  // Std of gene length
	RefGene    []string // The wild type genes
	GeneSnp    float64  // Percent of snps already in gene
	geneweight []int
	genesum    int
)

// Driver Gene Var

var (
	DriverFrac float64                  // Fraction of genes that are driver genes
	OncFrac    float64                  // Fraction of driver genes that are oncogenes
	OncMap     = make(map[int][]string) // Index of which refgene are og's and what mutation makes them oncogenes
	OncGene    []int                    // holds key of Onc map to reference later

	TsgGene     []int                   // Index of refgenes that are tsg's
	OncStrength = make(map[int]float64) // Size will number of oncogenes. Each value will represent oncogene strength
	TsgStrength = make(map[int]float64) // Size will be number of tsg's. Each value will represent tsg strength
)

// Mutate to table
var mutMap = map[string][]float64{
	"C*pG": []float64{0.93, 0.0, 0.02, 0.05}, // {T,C,G,A}
	"CpG*": []float64{0.01, 0.02, 0.00, 0.97},
	"TpC*": []float64{0.48, 0.00, 0.21, 0.31},
	"G*pA": []float64{0.33, 0.22, 0.00, 0.44},
	"T":    []float64{0.00, 0.39, 0.22, 0.39},
	"C":    []float64{0.51, 0.00, 0.20, 0.29},
	"G":    []float64{0.37, 0.13, 0.00, 0.50},
	"A":    []float64{0.25, 0.13, 0.62, 0.00},
}

// DNA Codon Table

var codonMap = [4][4][4]uint8{}

//
