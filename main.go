package main

import (
	"flag"
	"fmt"
)

var version string
var commit string
var branch string

func greeting(name string) (result string) {
	result = fmt.Sprintf("Hello %s!", name)
	return result
}

func main() {

	verisonPtr := flag.Bool("version", false, "Prints the version")

	flag.Parse()

	if *verisonPtr {
		fmt.Printf("Version: %s\n", version)
		fmt.Printf("Commit: %s\n", commit)
		fmt.Printf("Branch: %s\n", branch)
	}

	message := greeting("World")
	fmt.Println(message)
}
