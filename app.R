source('global.R')

ui <- dashboardPage(
  dashboardHeader(title = "GeoFish Dashboard"),
  
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("th"))
    ),
    
    selectInput(inputId = "select_cat",
                label = "Select category to observe",
                choices = names(lancomp[,7:12])),
    
    selectInput(inputId = "select_month",
                label = "Select Month",
                #"Names")
                choices = monthChoices,
                selected = "1"),
    
    selectInput(inputId = "select_year",
                label = "Select Year",
                choices = yearChoices,
                selected = "2009")
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              fluidRow(
                box(plotOutput("plot"))
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
    req(input$select_month)
    #filter data so that when a month and year is selected, it limits the data for the graph to that month and year
    graph <- lancomp %>% filter(le_month %in% input$select_month, le_year %in% input$select_year) %>% group_by(le_gear) %>% summarize(le_kg = sum(le_kg))
  })
    
    
    
  #plot the graph
  output$plot <- renderPlot({
    g <- ggplot(data(), aes(y = le_kg,x = le_gear))
    g+ geom_bar(stat = "sum")
    
  })
  #})
  
}

shinyApp(ui = ui, server = server)