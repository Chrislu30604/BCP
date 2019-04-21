package main

import (
	"encoding/json"
	"log"

	"github.com/gin-gonic/gin"
)

type User struct {
	Name        string `json:"name"`
	Email       string `json:"email"`
	Password    string `json:"password"`
	Dollars     string `json:"dollars"`
	Enddate     string `json:"enddate"`
	Description string `json:"description"`
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
