package lineage

// Cell Variables
var (
	//Cell cycle rates
	WtCycle float64
	CCycle  float64

	//Cell death rates
	WtDeath float64
	CDeath  float64
	MutRate float64 // how many bp mutate per genome per cell division
	RepFail float64 // Probability of failing to repair a mutation

)

// Nutrient Variables
// Make them a function of OGs
var (
	VO2    float64 = 1              // Production of O2
	RO2    float64 = .01            // Degradation of O2
	KO2    float64                  // Consumption of O2
	MinKO2 float64                  //Min consumption of O2
	Kec50  float64                  // Mean cancer cell Threshold for angiogenesis to start
	MaxO2  float64 = VO2 / RO2      // max O2 level
	CritO2 float64 = MaxO2 * .9     // Amount of o2 consumed below which
	NecrO2 float64 = MaxO2 - CritO2 // Amount at which necrosis kicks in

)

// CellStruct holds information about individual cells
type Seq struct {
	G   []uint16 // Which gene
	Pos []uint16 // Where on gene
	Nuc []byte   // New Nucleotide
}
type CellStruct struct {
	EventTime float64   // Time at which event occurs
	Event     int       // What type of event occurs; 0 = Apoptosis / 1 = Division
	GeneMut   Seq       // Map of gene to its mutated version in cell
	OncEffect []float64 // Index to an oncogenes effect in OncStrength
	TsgEffect []float64 // Index to a TSG's effect in TsgStrength
}
