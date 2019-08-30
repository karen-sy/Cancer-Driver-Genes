// package lineage contains the solvers, variables and event handlers for solving
// a stochastic cell lineage simulation
package lineage

import (
	"math"
)

// Gillespie uses the traditional Gillespie algorithm to handle which events occur and at what time they occur.
// as an input it takes 2 random numbers and whether the cell is a cancer. It's outputs are the time of the event and the type of the event

func Gillespie(rng []float64, cell *CellStruct, cellTot int, oncscore, tsgscore float64) (dt float64, event int) {

	v, d := updateRates(cell, cellTot, oncscore, tsgscore)
	Wt := v + d
	if rng[1] < v/Wt {
		event = 1
	}

	dt = -math.Log(rng[0]) / Wt

	return dt, event
}

func Division(key, ind int, cSlice []*[]*CellStruct, oncscore, tsgscore *float64, freeCells *[]*CellStruct) (*CellStruct, *CellStruct) {

	switch len(*freeCells) {
	case 0:
		var m CellStruct
		o := (*cSlice[key])[ind]
		m.GeneMut.G = make([]uint16, len(o.GeneMut.G))
		m.GeneMut.Pos = make([]uint16, len(o.GeneMut.Pos))
		m.GeneMut.Nuc = make([]byte, len(o.GeneMut.Nuc))

		m.OncEffect = make([]float64, len(o.OncEffect))
		m.TsgEffect = make([]float64, len(o.TsgEffect))
		copy(m.GeneMut.G, o.GeneMut.G)
		copy(m.GeneMut.Pos, o.GeneMut.Pos)
		copy(m.GeneMut.Nuc, o.GeneMut.Nuc)

		copy(m.TsgEffect, o.TsgEffect)
		copy(m.OncEffect, o.OncEffect)

		Apoptosis(key, ind, cSlice, oncscore, tsgscore)

		return &m, o
	default:
		m := (*freeCells)[0]
		o := (*cSlice[key])[ind]
		*freeCells = (*freeCells)[1:]
		m.GeneMut.G = make([]uint16, len(o.GeneMut.G))
		m.GeneMut.Pos = make([]uint16, len(o.GeneMut.Pos))
		m.GeneMut.Nuc = make([]byte, len(o.GeneMut.Nuc))

		copy(m.GeneMut.G, o.GeneMut.G)
		copy(m.GeneMut.Pos, o.GeneMut.Pos)
		copy(m.GeneMut.Nuc, o.GeneMut.Nuc)

		copy(m.TsgEffect, o.TsgEffect)
		copy(m.OncEffect, o.OncEffect)
		Apoptosis(key, ind, cSlice, oncscore, tsgscore)

		return m, o

	}

	panic("Got to here")
	// remove cell from map
	var m CellStruct
	var o CellStruct
	return &m, &o

}

// func copyCell(x *CellStruct, n *CellStruct) {

// 	if len(x.GeneMut) > 0 {
// 		for k, v := range x.GeneMut {
// 			n.GeneMut[k] = v
// 		}
// 		for k, v := range x.OncEffect {
// 			n.OncEffect[k] = v
// 		}
// 		for k, v := range x.TsgEffect {
// 			n.TsgEffect[k] = v
// 		}
// 	}
// }

func Apoptosis(key, ind int, cSlice []*[]*CellStruct, oncscore, tsgscore *float64) {
	cell := (*cSlice[key])[ind]

	//	onc := 0.0
	for _, val := range cell.OncEffect {
		*oncscore -= val
	}

	//	tsg := 0.0
	for _, val := range cell.TsgEffect {
		*tsgscore -= val
	}
	l := len(*cSlice[key])
	(*cSlice[key])[ind] = (*cSlice[key])[l-1]
	(*cSlice[key])[l-1] = nil
	(*cSlice[key]) = (*cSlice[key])[:l-1]
	// copy(cSlice[key][ind:], cSlice[key][ind+1:])
	// cSlice[key][len(cSlice[key])-1] = nil
	// cSlice[key] = cSlice[key][:len(cSlice[key])-1]
	// cSlice[key] = append(cSlice[key][:ind], cSlice[key][ind+1:]...)
}

func updateRates(cell *CellStruct, cellTot int, oncscore, tsgscore float64) (newV, newD float64) {
	// note: change o2 to include angio
	onc := 0.0
	for _, val := range cell.OncEffect {
		onc += val
	}
	tsg := 0.0
	for _, val := range cell.TsgEffect {
		tsg += val
	}
	cancerScore := (oncscore + tsgscore) / float64(2*cellTot)
	ko2 := KO2 - (KO2-MinKO2)/(1+Kec50/cancerScore) // This needs to be a population wide event not cellular

	o2 := VO2 / (RO2 + float64(cellTot)*ko2) // Amount of O2 with c cells
	cellEfficiency := 1 - (MaxO2-o2)/CritO2

	newV = WtCycle - (WtCycle-CCycle)/(1+math.Pow(Kec50/onc, 4))
	newV *= cellEfficiency
	newD = WtDeath - (WtDeath-CDeath)/(1+math.Pow(Kec50/tsg, 4))
	newD *= cellEfficiency
	necrosis := 1 / (1 + math.Pow(o2/NecrO2, 10))
	newD += necrosis
	return
}
