###################
# ui.R
# 
# UI controller. 
# Used to define the graphical aspects of the app.
###################

library(bslib)
library(leaflet)
library(DT)

ui <- 
  navbarPage(
    id = "tabs",
    theme = bs_theme(bootswatch = "cosmo",
                     primary = "#4CAF50",
                     secondary = "#555555",
                     base_font = font_google("Roboto")
    ),
    div(
      tags$img(src = "DDLLogo_white.png", style = "height: 40px; margin-right: 10px;"),
      style = "font-size: 24px; font-weight: bold; padding: 0 20px;",
      "Generic database release template"
    ),    
    header = tags$style(
      HTML("
      .navbar-nav {
        margin: 0 auto;
        display: flex;
        justify-content: center;
      }
      .navbar-nav > li > a {
        font-size: 16px;
        font-weight: 500;
        padding: 15px 20px;
      }
      .navbar { position: sticky; top: 0; z-index: 1020; }
    ")
    ),
    
    # Landing page
    tabPanel(
      tags$div(icon("home"), "Home"),
      fluidPage(
        tags$div(
          style = "max-width: 900px; margin: 0 auto; padding: 40px 20px; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: #333333; line-height: 1.8;",
          
          tags$div(
            style = "background-color: #f9f9f9; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
            
            # Title and subtitle
            tags$h1(
              style = "font-size: 48px; font-weight: 300; text-align: center; color: #4CAF50; margin-bottom: 20px;",
              "Generic template for deploying datasets"
            ),
            tags$h2(
              style = "font-size: 24px; font-weight: 300; text-align: center; color: #555555; margin-bottom: 40px;",
              "This app can serve as a template to deploy other datasets either in CSV or SQL liteformats. Feel free to modify the structure of the app, as well as to replace the text and adjust visuals, structure of the table, etc throughout the app."
            ),
            #br(),
            tags$div(
              style = "text-align: center; margin-top: 30px;",
              tags$img(
                src = "globe_animals.png", 
                style = "max-width: 40%; height: auto; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); border-radius: 8px;"
              )
            ),
            br(),
            # Introduction text
            tags$p(
              style = "text-align: justify; margin-bottom: 15px;",
              "The Data tab includes samples of visuals that can be generated from the dataset, a table showing the latest version of the dataset, as well as additional functionality concerned with modals associated with rows in the data table."
            )
          )
        )
      )
    ),
    
    # Dataset page (updated for penguins)
    tabPanel(
      value = "Populations_tab",
      tags$div(icon("globe"), "Data"),
      fluidPage(
        tags$div(
          style = "max-width: 900px; margin: 0 auto; padding: 20px 0; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: #333333; line-height: 1.8;",
          
          tags$div(
            style = "background-color: #f9f9f9; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
            
            tags$h3(
              style = "font-size: 24px; font-weight: bold; color: #4CAF50; text-align: center; margin-bottom: 20px;",
              "Sample dataset: Palmer penguin traits"
            ),
            tags$p(
              style = "text-align: justify; margin-bottom: 15px;",
              "Graph showing trait distributions for particular penguin species. The table below, allow you to explore the sampling in more detail as well as and sex-ratio information."
            )
          )
        ),
        
        # Plot section
        tags$div(
          style = "max-width: 1100px; margin: 40px auto; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
          
          tags$h4(style = "font-size: 20px; font-weight: bold; color: #4CAF50; margin-bottom: 15px;",
                  "Distribution of morphological traits"),
          
          plotOutput("distPlot", height = "500px")
        ),
        
        # Table section
        tags$div(
          style = "max-width: 1100px; margin: 40px auto; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
          
          tags$h4(style = "font-size: 20px; font-weight: bold; color: #4CAF50; margin-bottom: 15px;",
                  "Species summary table"),
          
          tags$p("Click on a species to view island-specific statistics, sampling year, and sex ratio details."),
          
          DTOutput("speciesTable")
        )
      )
    ),
    
    # Help tab
    tabPanel(
      tags$div(icon("question-circle"), "Help"),
      fluidPage(
        tags$div(
          style = "max-width: 900px; margin: 0 auto; padding: 40px 20px; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: #333333; line-height: 1.8;",
          
          # Help introduction
          tags$div(
            style = "background-color: #f9f9f9; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
            tags$h1(
              style = "font-size: 36px; font-weight: bold; text-align: center; color: #4CAF50; margin-bottom: 20px;",
              "Help and FAQs"
            ),
            tags$p(
              style = "text-align: center; color: #555555; margin-bottom: 40px;",
              "Please contact ",
              tags$a(href = "mailto:kcb7@arizona.edu", "Dr. Kiran Basava"),
              "or",
              tags$a(href = "mailto:cromanpa@arizona.edu", "Dr. Cristian Román"),
              " with questions!"
            )
            
          ),
          
          # FAQ Section
          tags$div(
            style = "margin-top: 20px;",
            
            # Question 1
            tags$div(
              style = "margin-bottom: 30px; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
              tags$h4(
                style = "font-size: 20px; font-weight: bold; color: #4CAF50; margin-bottom: 10px;",
                "Where can I find the associated code?"
              ),
              tags$p(
                style = "text-align: justify; margin: 0;",
                tags$a(href = "https://github.com/datadiversitylab/generic_shiny_data", "Here is the GitHub repo.")
              )
            ),
            
            # Question 2
            tags$div(
              style = "margin-bottom: 30px; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
              tags$h4(
                style = "font-size: 20px; font-weight: bold; color: #4CAF50; margin-bottom: 10px;",
                "How can I contribute data to the template?"
              ),
              tags$p(
                style = "text-align: justify; margin: 0;",
                "You can email us or open an issue on GitHub. We would love to have your input!"
              )
              
            )
          )
        )
      )
    )
  )
