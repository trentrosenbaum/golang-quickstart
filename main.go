package main

import "fmt"

var version string

func greeting(name string) (result string) {
	result = fmt.Sprintf("Hello %s!", name)
	return result
}

func main() {
	message := greeting("World")
	fmt.Println(message)
}
