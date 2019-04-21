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

	router.LoadHTMLGlob("dist/index.html")
	router.GET("/", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.html", nil)
	})
	router.NoRoute(func(c *gin.Context) {
		c.File("dist/index.html")
	})
	router.Static("/css", "./dist/css")
	router.Static("/img", "./dist/img")
	router.Static("/js", "./dist/js")

	api := router.Group("/launch")
	{
		api.POST("/propose", handlePropose)
	}
	router.Run(":8081")
}
