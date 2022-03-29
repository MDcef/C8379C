source('global.R')

ui <- dashboardPage(
  dashboardHeader(title = "GeoFish Dashboard"),
  
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("th"))
    ),
    
    selectInput(inputId = "select_cat",
                label = "Select category to observe",
                choices = names(lancomp[,c(7,8,11,12)])),
    
    selectInput(inputId = "select_month",
                label = "Select Month",
                #"Names")
                choices = monthChoices,
                selected = "1"),
    
    selectInput(inputId = "select_year",
                label = "Select Year",
                choices = yearChoices,
                selected = "2009"),
    
    selectInput(inputId = "select_species",
                label = "Select Species",
                choices = speChoices),
    
    selectInput(inputId = "select_gear",
                label = "Select Gear Type",
                choices = gearChoices,
                selected = "Driftnets")
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              fluidRow(
                tabBox(
                  tabPanel("le_graph", "Total sum of selected species caught, per gear type, for chosen category, month and year",
                           plotOutput("plot", height = 400, width = 800)),
                  tabPanel("totals_graph", "Please select a Total Category, Gear Type, Month and Year",
                           plotOutput("plot2", height = 400, width = 800))
                           
                )
              )
      ),
      tabItem(tabName = "dashboard",
              fluidRow(
                textOutput("graph_choices"))
      ),
      
      tabItem(tabName = "dashboard",
              fluidRow(
                box("mode_gear", width = 300),   #gear with which most amount of selected species are caught in terms of weight/money
                infoBoxOutput("mode_species", width = 3),   #most commonly caught species by selected gear
                infoBoxOutput("mode_year", width = 3)   #year in which most of selected species was caught
              )
      )
    )
  )
)


server <- function(input, output, session){
  
  #use observe to automatically retrieve row names for months. This was slower so opted for source from global
  # observe({
  #   updateSelectInput(session, "select_month", choices = lancomp$le_month)
  # })
    
  #summarise data and plot chart
  data <- reactive({
    req(input$select_month, input$select_year, input$select_cat, input$select_species)
    #filter data so that when a month and year is selected, it limits the data for the graph to that month and year
    graph <- lancomp %>% filter(le_month %in% input$select_month, le_year %in% input$select_year, species_common %in% input$select_species) %>% group_by(le_gear) %>% summarize(le_kg = sum(eval(as.symbol(input$select_cat))))
  })
  
  #plot the graph
  output$plot <- renderPlot({
    g <- ggplot(data(), aes(y = le_kg, x = le_gear))
    g+ geom_bar(stat = "sum")
  })
  
  #2nd tab
  data2 <- reactive({
    req(input$select_gear, input$select_cat, input$select_month, input$select_year)
    graph2 <- lancomp %>% filter(le_month %in% input$select_month, le_year %in% input$select_year, gear_name %in% input$select_gear) %>% group_by(species_common) %>% summarize(total_lw_rat = sum(eval(as.symbol(input$select_cat))))
  })
  
  output$plot2 <- renderPlot({
    g2 <- ggplot(data2(), aes(y = total_lw_rat, x = species_common))
    g2+ geom_bar(stat = "sum")
  })
  
  #infoBox outputs
  infodata1 <- reactive({
    req(input$select_species)
    box1 <- lancomp %>% filter(species_common %in% input$select_species) %>% summarize(val1 = mode(gear_name))
  })
  
  output$mode_gear <- renderInfoBox({
    infoBox(
      title = "Modal Gear",
      value = 10 * 2,
      icon = icon("fire")
    )
  })
  
  
  output$graph_choices <- renderText({
    paste("Viewing", input$select_cat, "for", input$select$month, ",", input$select_year)
  })
  
}

shinyApp(ui = ui, server = server)