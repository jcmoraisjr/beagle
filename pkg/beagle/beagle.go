package main

import (
	"fmt"
	"github.com/jcmoraisjr/beagle/pkg/version"
)

func main() {
	fmt.Print("Success!\n")
	fmt.Printf("Product.....: %v\n", version.Product)
	fmt.Printf("Repository..: %v\n", version.Repository)
	fmt.Printf("Version.....: %v\n", version.Version)
	fmt.Printf("Timestamp...: %v\n", version.Timestamp)
}
