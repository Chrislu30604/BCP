package main

import (
	"net/http"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()
	config := cors.DefaultConfig()
	config.AddAllowHeaders("*")
	config.AllowAllOrigins = true
	config.AllowMethods = []string{"POST", "GET"}
	router.Use(cors.New(config))

	router.LoadHTMLGlob("../frontend/dist/index.html")
	router.GET("/", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.html", nil)
	})
	router.NoRoute(func(c *gin.Context) {
		c.File("../frontend/dist/index.html")
	})
	router.Static("/css", "../frontend/dist/css")
	router.Static("/img", "../frontend/dist/img")
	router.Static("/js", "../frontend/dist/js")

	launch := router.Group("/launch")
	{
		launch.POST("/propose", handlePropose)
	}
	reg := router.Group("/register")
	{
		reg.POST("/queryName", handleQueryName)
		reg.POST("/register", handleRegister)
	}

	router.Run(":8081")
}
