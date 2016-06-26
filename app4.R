
# Bodem geleidbaarheid

feat <- data_BG
feat <- feat[1:10]
names(feat) <- c("Lat", "Lon", "z", "half", "een", "anderhalf", "drie", "klassen", "outlier", "name")
feat <- feat %>% 
  mutate(half_f = factor(round(half, digits = 1)))

dirs <- list.dirs("data/bodemscan")[seq(2,230, by = 2)]
name <- substring(dirs, 32)
date <- ymd(substring(dirs, 16, 23))
csv  <- paste0(substring(dirs, 16), ".csv")
dirs_csv <- paste0(dirs, "/", csv)

lijst <- data_frame(id = seq_along(dirs), 
                    dirs = dirs, 
                    name = name, 
                    date = date,
                    csv  = csv,
                    dirs_csv = dirs_csv)

bodemscan_min <- min(feat[, 4:7])
bodemscan_max <- max(feat[, 4:7])

perceel_bg_table <- data_frame(id = unique(feat$name), name = substring(unique(feat$name), 7))
perceel_bg <- sort(perceel_bg_table$name)
perceel_p <- sort(unique(data_p$names))

both <- table(c(perceel_bg, perceel_p))[table(c(perceel_bg, perceel_p)) > 1]

depths <- names(feat)[4:7]

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      h2("SELECT DATA"),
      p("Note: graphs will appear AFTER you select data!"),
      selectInput("perceel_bg", "Perceel", 
                         choices = perceel_bg,
                         selected = perceel_bg[1]),
      radioButtons("depth", "Diepte",
                   choices = depths,
                   selected = depths[1]),
      actionButton("select_bg", "Selecteer Bodem geleidbaarheid"),
      selectInput("perceel_p", "Perceel", 
                  choices = perceel_p,
                  selected = perceel_p[1]),
      actionButton("select_p", "Selecteer Opbrengst"),
      textOutput("both")
    ),
    
    mainPanel(
      h2("SEE THE PLOTS"),
      plotOutput("plot_bg"),
      plotOutput("plot_p")
    )
  )
)


server <- function(input, output) {

  databg <- eventReactive(input$select_bg, {
    lookup <- perceel_bg_table$id[perceel_bg_table$name == input$perceel_bg]
    data <- feat %>% 
      filter(name == lookup)
    
    if(dim(data)[1] > 10000) {
      data <- data[sample(dim(data)[1], 10000),]
    }
    
    data <- data[c("Lat", "Lon", input$depth)]
    
    names(data) <- c("Lat", "Lon", "colour")
    
    data
  })
  
  datap <- eventReactive(input$select_p, {
    data <- data_p %>% 
      filter(names == input$perceel_p)
    
    if(dim(data)[1] > 10000) {
      data <- data[sample(dim(data)[1], 10000),]
    }
    
    data
  })
    
  output$plot_bg <- renderPlot({
    ggplot(data = databg(), 
           aes(x = Lat, y = Lon, col = colour)) + 
      geom_point() + 
      scale_colour_gradientn(colours = terrain.colors(10)) +
      theme_tufte()
  })
  
  output$plot_p <- renderPlot({
    ggplot(data = datap(), 
           aes(x = Lat, y = Lon, col = yield)) + 
      geom_point() + 
      scale_colour_gradientn(colours = terrain.colors(10)) +
      theme_tufte()
  })
  
  output$both <- renderText({
    paste0(names(both), sep = " - ")
  })
  
}



shinyApp(ui = ui, server = server)
