package main

import (
	"fmt"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/suite"
	"testing"
)

type GreetingTestSuite struct {
	suite.Suite
	Name string
}

func (suite *GreetingTestSuite) SetupTest() {
	//fmt.Println("Executing Setup.")
	suite.Name = "John"
}

func (suite *GreetingTestSuite) TearDownTest() {
	//fmt.Println("Executing TearDown.")
}

//  test functions

func (suite *GreetingTestSuite) TestSayingHello() {

	// Given
	name := suite.Name

	// When
	result := greeting(name)

	// Then
	expected := fmt.Sprintf("Hello %s!", name)

	assert.Equal(suite.T(), expected, result)
}

func TestGreetingTestSuite(t *testing.T) {
	suite.Run(t, new(GreetingTestSuite))
}
