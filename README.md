# golang-quickstart
[![Build Status](https://travis-ci.org/trentrosenbaum/golang-quickstart.svg?branch=introduce-travis-ci)](https://travis-ci.org/trentrosenbaum/golang-quickstart)

This is a simple quickstart project written in Go.  The aim of the repo is to provide a starting point for a new Go project.

The project provides main.go and a main_test.go files that tests the printing of a greeting to the terminal.

## Makefile

A Makefile is provided to test, build and package the project.  Additionally the Makefile will allow the project to 
be distributed as three separate binaries cover, Linux, MacOS and Windows.

The dependency management is fulfill through go modules.
