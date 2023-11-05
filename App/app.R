#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyFiles)
source('aux.R')
source('UHI.R')
library (stringr)
library(raster)
library(leaflet)
library(sf)
library(leaflet.extras)
library(shinydashboard)

# Define UI for application 
ui <- dashboardPage(
  
    dashboardHeader(title = "URSUS_UHI"),
    
    dashboardSidebar(),
    
    dashboardBody(
      
      fluidRow(
        
        class = "text-center",
        
          
        box(
            shinyDirButton('folder', 'Select image', 'Please select a landsat image folder', FALSE),
            status = "primary",
            solidHeader = TRUE,
            title = "Select landsat-8 image unzip folder",
            width = 2,
        ),
          

      
        box(
            title = "Select area for determining the more disfavourable areas due to urban heat island ",
            status = "info",
            solidHeader = TRUE,
            leafletOutput("mymap"),
            p(),
            actionButton("processUrbanArea", "Process Urban Area"),
            width = 7
     
        ),
        
        
        box(
          title = "Cropped Landsat Image",
          status = "danger",
          solidHeader = TRUE,
          plotOutput("CROPPED"),
          width = 3
        )
        
        
      ),
      
      fluidRow(
        
        class = "text-center",
        
        
        box(
          title = "LST",
          status = "danger",
          solidHeader = TRUE,
          plotOutput("LST"),
          width = 4
        ),
        
        box(
          title = "NDVI",
          status = "success",
          solidHeader = TRUE,
          plotOutput("NDVI"),
          width = 4
        ),
        
        box(
          title = "DAI",
          status = "danger",
          solidHeader = TRUE,
          plotOutput("DAI"),
          width = 4
        )
        
      )
      
    )
    
)

# Define server logic 
server <- function(input, output, session) {
  
  # Select image folder logic
  
  shinyDirChoose(input, 'folder', roots=c(wd='./data'), filetypes=c())
  
  observe({  
    
    # If a landsat 8 folder is selected, a multiband layer from image is created
    if(!is.integer(input$folder)){
      
      shinyDirChoose(input, 'folder', roots=c(wd='./data'))
      dirinfo <- parseDirPath(roots=c(wd='./data'), input$folder)
      
      # Reag landsat 8 satellite multiband and metadata from landsat 8 image
      multibandLayer <<- readMultibandRasterLayer(dirinfo)
      
      extentCoordinatesLatLng <- utmToGPSExtent (multibandLayer[[1]])
      
      #Leflet map
      output$mymap <- renderLeaflet({
        
        leaflet() %>% 
          
          # center leaflet map on landsat image coordinates
          fitBounds(lng1 = extentCoordinatesLatLng[[1]][[1]] , lng2 = extentCoordinatesLatLng[[1]][[2]] ,
                  lat1 = extentCoordinatesLatLng[[2]][[1]], lat2 = extentCoordinatesLatLng[[2]][[2]]
                 ) %>%
          
          #plot rectangle with covered area over leaflet map
          addRectangles(
            lng1=extentCoordinatesLatLng[[1]][[1]], lat1=extentCoordinatesLatLng[[2]][[1]],
            lng2= extentCoordinatesLatLng[[1]][[2]], lat2=extentCoordinatesLatLng[[2]][[2]],
            fillColor = "transparent"
          ) %>%
          
        
          addDrawToolbar(
            targetGroup='draw',
            polylineOptions = FALSE,
            polygonOptions = FALSE,
            circleOptions = FALSE,
            rectangleOptions = drawRectangleOptions(),
            markerOptions = FALSE,
            circleMarkerOptions = FALSE, 
            singleFeature = FALSE,
            editOptions = editToolbarOptions(selectedPathOptions = selectedPathOptions())
          ) %>%
          
          
          addProviderTiles('Esri.WorldImagery')
        
      })
      
    }
    
  })
  
  #Observer polygon crop area over map
  feature <- eventReactive( input$mymap_draw_new_feature, {
    input$mymap_draw_new_feature
  })
  
  #Observer polygon crop area over map
  observeEvent(input$processUrbanArea, {
    
    # read coords from polygon cropped area
    coords_ <- feature()$geometry$coordinates[[1]]
 
    
    croppedImage <- cropSelectedAreaFromLandsatImage (coords_,multibandLayer)
    
    #Plot RDG image landsat8
    output$CROPPED <- renderPlot ({
      plotRGBImage(croppedImage)
    })
    
    #calculate NDVI
    output$NDVI <- renderPlot ({
      plot(calculateNDVI (croppedImage))
    })
    
  })
  
    
}

# Run the application 
shinyApp(ui = ui, server = server)
