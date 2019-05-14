package main

import (
	"context"
	"encoding/json"
	"log"
	"net/http"
	"regexp"
	"time"

	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

var client *mongo.Client

// User defined the launch project content
type User struct {
	Name        string `json:"name"`
	Email       string `json:"email"`
	Password    string `json:"password"`
	Dollars     string `json:"dollars"`
	Enddate     string `json:"enddate"`
	Description string `json:"description"`
}

type Register struct {
	Base
	Detail
}

type Base struct {
	ID       string `json:"id" bson:"id"`
	Password string `json:"password" bson:"password"`
	Email    string `json:"email" bosn:"email"`
}
type Detail struct {
	Name           string `json:"name"`
	Identification string `json:"Identification"`
	Birth          string `json:"Birth"`
}

// RegisterUser define user's detail
type RegisterUser struct {
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
	parser := Base{}
	// 1.Check Receive Data
	rawdata, err := c.GetRawData()
	if err != nil {
		log.Println("ERROR Json Raw Data")
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	// 2.Unserialize
	err = json.Unmarshal(rawdata, &parser)
	if err != nil {
		log.Println("ERROR Json Key")
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	// 3. Regex Check
	regexID := regexp.MustCompile("^[a-zA-Z0-9]*$")
	regexEmail := regexp.MustCompile(`^[a-z0-9._%+\-]+@[a-z0-9.\-]+\.[a-z]{2,4}$`)
	if regexID.MatchString(parser.ID) && regexEmail.MatchString(parser.Email) && len(parser.Password) >= 6 {

		// 4.Find Name in Mongodb
		res := findMongoDB("user", "account", "id", parser.ID)
		if res != true {
			log.Println("User Already in use")
			c.JSON(http.StatusBadRequest, gin.H{"status": "User Already in use"})
			return
		}
		// 5. Find Email in Mongodb
		res = findMongoDB("user", "account", "email", parser.Email)
		if res != true {
			log.Println("Email Already in use")
			c.JSON(http.StatusBadRequest, gin.H{"status": "Email Already in use"})
			return
		}

		log.Println("Query Success", parser)
		c.JSON(http.StatusOK, gin.H{"status": "OK"})
	} else {
		log.Fatal("ERROR Json Key")
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
}

func handleRegister(c *gin.Context) {
	parser := Register{}
	// 1.Check Receive Data
	rawdata, err := c.GetRawData()
	if err != nil {
		log.Println("ERROR Json Raw Data")
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	// 2.Unserialize
	err = json.Unmarshal(rawdata, &parser)
	if err != nil {
		log.Println("ERROR Json Key")
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	// 3. Regex Check
	regexID := regexp.MustCompile("^[a-zA-Z0-9]*$")
	regexEmail := regexp.MustCompile(`^[a-z0-9._%+\-]+@[a-z0-9.\-]+\.[a-z]{2,4}$`)
	regexName := regexp.MustCompile("^[a-zA-Z]*$")
	regexBirth := regexp.MustCompile(`\d{2}/\d{2}/\d{4}`)
	if regexID.MatchString(parser.Base.ID) &&
		regexEmail.MatchString(parser.Base.Email) &&
		regexName.MatchString(parser.Detail.Name) &&
		regexBirth.MatchString(parser.Detail.Birth) &&
		len(parser.Base.Password) >= 6 {
		log.Println("Insert in MongoDB")
		res := insertMongoDB("user", "account", &parser)
		if res != true {
			log.Println("Insert Fail")
			c.JSON(http.StatusBadRequest, gin.H{"error": "Insert Fail"})
			return
		}
		c.JSON(http.StatusOK, gin.H{"status": "OK"})
	}
}

func findMongoDB(databaseName string, collectionName string, queryKey string, data string) bool {
	// Connect to mongodb
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	client, err := mongo.Connect(ctx, options.Client().ApplyURI("mongodb://localhost:27017"))
	if err != nil {
		log.Fatal("Error connect to Mongodb", err)
	}
	defer cancel()
	// Query Name
	collection := client.Database(databaseName).Collection(collectionName)
	cur, err := collection.Find(context.Background(), bson.M{queryKey: data})
	defer cur.Close(ctx)
	// If find, return false
	for cur.Next(ctx) {
		var user Base
		if err := cur.Decode(&user); err != nil {
			log.Fatal(err)
		}
		log.Println(user)
		return false
	}
	return true
}

func insertMongoDB(databaseName string, collectionName string, data interface{}) bool {
	// Connect to mongodb
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	client, err := mongo.Connect(ctx, options.Client().ApplyURI("mongodb://localhost:27017"))
	if err != nil {
		log.Fatal("Error connect to Mongodb", err)
		return false
	}
	defer cancel()
	// Insert Bson to mongodb
	collection := client.Database(databaseName).Collection(collectionName)
	res, err := collection.InsertOne(context.Background(), data)
	if err != nil {
		log.Println("Error Insert", err)
		return false
	}
	log.Println("ObjectID: ", res.InsertedID)
	return true
}
