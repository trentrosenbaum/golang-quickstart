package main

import (
	"flag"
	"fmt"
)

var Version string
var Build string

func greeting(name string) (result string) {
	result = fmt.Sprintf("Hello %s!", name)
	return result
}

func main() {

	verisonPtr := flag.Bool("version", false, "Prints the version")
	buildPtr := flag.Bool("build", false, "Prints the build")
	flag.Parse()

	if *verisonPtr {
		fmt.Printf("Version: %s\n", Version)
	}

	if *buildPtr {
		fmt.Printf("Build: %s\n", Build)
	}

	message := greeting("World")
	fmt.Println(message)
}
