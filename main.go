package main

import (
	"flag"
	"fmt"
)

var version string
var build string

func greeting(name string) (result string) {
	result = fmt.Sprintf("Hello %s!", name)
	return result
}

func main() {

	verisonPtr := flag.Bool("version", false, "Prints the version")
	buildPtr := flag.Bool("build", false, "Prints the build")
	flag.Parse()

	if *verisonPtr {
		fmt.Printf("Version: %s\n", version)
	}

	if *buildPtr {
		fmt.Printf("Build: %s\n", build)
	}

	message := greeting("World")
	fmt.Println(message)
}
