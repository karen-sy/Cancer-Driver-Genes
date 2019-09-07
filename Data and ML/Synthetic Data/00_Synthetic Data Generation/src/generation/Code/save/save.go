package save

import (
	"encoding/csv"
	"fmt"
	"os"
	"reflect"
	"strconv"
	"strings"
)

// var (
// 	t         int
// 	cells     []bool
// 	cancer    []bool
// 	geneA     []string
// 	geneB     []string
// 	rate      float64
// 	overwrite bool
// )

// type saveStruct struct {
// 	T      *int
// 	Cells  *[]bool
// 	Cancer *[]bool
// 	GeneA  *[]string
// 	GeneB  *[]string
// 	Rate   *float64
// }

// func main() {
// 	file := "Test.csv"
// 	if overwrite {
// 		_ = os.Remove(file)
// 	}
// 	cells = []bool{true, true, true}
// 	save := saveStruct{
// 		T:      &t,
// 		Cells:  &cells,
// 		Cancer: &cancer,
// 		GeneA:  &geneA,
// 		GeneB:  &geneB,
// 		Rate:   &rate,
// 	}

// 	SaveFile(file, save)
// }

// SaveHeader saves the fields of a struct as a header
func SaveHeader(file, ext string, S interface{}) {
	var f, err = os.OpenFile(file+ext, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	defer f.Close()
	warning(err)

	w := csv.NewWriter(f)
	defer w.Flush()

	err = w.Write(parseStructHeader(S))
	warning(err)
}

// SaveFile saves the contents of a struct to a file
func SaveFile(file, ext string, c chan interface{}, close, done chan int) {
	var f, err = os.OpenFile(file+ext, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	defer f.Close()
	warning(err)

	w := csv.NewWriter(f)
	for {
		select {
		case S := <-c:
			err = w.Write(parseStruct(S))
			warning(err)
			w.Flush()
			done <- 1
		case <-close:
			w.Flush()
			break
		}
	}
}

// parseStruct takes a struct as an inteface and iterates over its fields to create tab separated strings of the values
func parseStruct(S interface{}) (s []string) {
	t := reflect.ValueOf(S)
	for i := 0; i < t.NumField(); i++ {
		f, err := makeString(t.Field(i).Interface())
		warning(err)
		s = append(s, f)
	}
	return s
}

// parseStructHeader takes a struct as an interface and interates over the fields to create a tab separated string of the fields
func parseStructHeader(S interface{}) (s []string) {
	t := reflect.ValueOf(S)
	for i := 0; i < t.NumField(); i++ {
		name := t.Type().Field(i).Name
		f, err := makeString(&name)
		warning(err)
		s = append(s, f)
	}
	return s
}

// makeString Takes an interface x and transforms its contents into a tab separated string
func makeString(x interface{}) (s string, err error) {

	v := reflect.Indirect(reflect.ValueOf(x))
	switch v.Kind() {
	case reflect.Slice:
		N := v.Len()
		switch v.Type().Elem().Kind() {
		case reflect.Int:
			X := x.(*[]int)
			for i := 0; i < N; i++ {
				s += strconv.Itoa((*X)[i]) + "\t"
			}
			return s, nil
		case reflect.Bool:
			X := x.(*[]bool)
			for i := 0; i < N; i++ {
				s += strings.Title(strconv.FormatBool((*X)[i])) + "\t"
			}
			return s, nil
		case reflect.Float64:
			X := x.(*[]float64)
			for i := 0; i < N; i++ {
				s += strconv.FormatFloat((*X)[i], 'E', -1, 64) + "\t"
			}
			return s, nil
		case reflect.String:
			X := x.(*[]string)
			for i := 0; i < N; i++ {
				s += (*X)[i] + "\t"
			}
			return s, nil
		}

	default:
		switch v.Kind() {
		case reflect.Int:
			X := x.(*int)
			return strconv.Itoa(*X), nil
		case reflect.Bool:
			X := x.(*bool)
			return strings.Title(strconv.FormatBool(*X)), nil
		case reflect.Float64:
			X := x.(*float64)
			return strconv.FormatFloat(*X, 'E', -1, 64), nil
		case reflect.String:
			X := x.(*string)
			return *X, nil
		}

	}
	err = fmt.Errorf("\n Error in makeString Value is %v ", v)
	return s, err
}

// panic if error
func warning(err error) {
	if err != nil {
		panic(err)
		// log.Fatal(err)
	}
}
