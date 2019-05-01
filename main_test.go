package main

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/suite"
)

type GreetingTestSuite struct {
	suite.Suite
	Name string
}

func (suite *GreetingTestSuite) SetupTest() {
	fmt.Println("Executing Setup.")
	suite.Name = "John"
}

func (suite *GreetingTestSuite) TearDown() {
	fmt.Println("Executing TearDown.")
}

//  test functions

func (suite *GreetingTestSuite) TestSayingHello() {

	// Given
	name := suite.Name

	// When
	result := greeting(name)

	// Then
	suite.Equal(fmt.Sprintf("Hello %s!", name), result, "Greeting was not correct.")

}

func TestGreetingTestSuite(t *testing.T) {
	suite.Run(t, new(GreetingTestSuite))
}
