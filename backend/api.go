package main

import (
	"encoding/json"
	"log"

	"github.com/gin-gonic/gin"
)

// User defined the launch project content
type User struct {
	Name        string `json:"name"`
	Email       string `json:"email"`
	Password    string `json:"password"`
	Dollars     string `json:"dollars"`
	Enddate     string `json:"enddate"`
	Description string `json:"description"`
}

// RegisterUser define user's detail
type RegisterUser struct {
	Base struct {
		ID       string `json:"id"`
		Password string `json:"password"`
		Email    string `json:"email"`
	}
	Detail struct {
		Name           string `json:"name"`
		Identification string `json:"Identification"`
		Birth          string `json:"Birth"`
	}
}

func handlePropose(c *gin.Context) {
	parser := User{}
	rawdata, err := c.GetRawData()
	if err != nil {
		panic(err)
	}
	log.Println(string(rawdata))
	json.Unmarshal(rawdata, &parser)

	log.Println(parser)
}

func handleQueryName(c *gin.Context) {
	parser := RegisterUser{Base{}}
	rawdata, err := c.GetRawData()
	if err != nil {
		panic(err)
	}
	log.Println(string(rawdata))
	json.Unmarshal(rawdata, &parser)
	log.Println(parse)
}
