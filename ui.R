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
      "Template"
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
              "Lorem ipsum dolor sit amet consectetur adipiscing elit. Dolor sit amet consectetur adipiscing elit quisque faucibus."
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
              "Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos."
            )
          )
        )
      )
    )
    
    ,
    
    # Populations page (updated for penguins)
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
              " if your questions are not answered below!"
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
                "How do I search for populations?"
              ),
              tags$p(
                style = "text-align: justify; margin: 0;",
                "Use the ‘search’ bar in the population data table to search for specific groups, species, or locations."
              )
            ),
            
            # Question 2
            tags$div(
              style = "margin-bottom: 30px; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
              tags$h4(
                style = "font-size: 20px; font-weight: bold; color: #4CAF50; margin-bottom: 10px;",
                "How can I download data?"
              ),
              tags$p(
                style = "text-align: justify; margin: 0;",
                "Please visit our ",
                tags$a(href = "https://github.com/datadiversitylab/ACDB_datarelease", 
                       "GitHub repository"),
                " for the current release of the SQLite database, or you can download separate CSV files for each table (in the table_csvs folder)."
              )
              
            ),
            
            # Question 3
            tags$div(
              style = "margin-bottom: 30px; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
              tags$h4(
                style = "font-size: 20px; font-weight: bold; color: #4CAF50; margin-bottom: 10px;",
                "How can I contribute data to the database?"
              ),
              tags$p(
                style = "text-align: justify; margin: 0;",
                "We are currently working on a pipeline for contributions from researchers. For now, please email ",
                tags$a(href = "mailto:kcb7@arizona.edu", "Dr. Basava"),
                " with a description of the sort of data you would like to be added. Thank you for your interest in contributing data!"
              )
              
            ),
            
            # Question 4
            tags$div(
              style = "margin-bottom: 30px; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
              tags$h4(
                style = "font-size: 20px; font-weight: bold; color: #4CAF50; margin-bottom: 10px;",
                "Where can I learn more about animal culture?"
              ),
              tags$p(
                "Some recent and accessible reviews of the research on animal culture include:", 
                tags$br(),
                tags$a(href = "https://onlinelibrary.wiley.com/doi/10.1002/bies.201900060", 
                       "Allen, Jenny A. (2019). Community through Culture: From Insects to Whales: How Social Learning and Culture Manifest across Diverse Animal Communities."),
                tags$br(),
                tags$a(href = "https://www.science.org/doi/10.1126/science.abe6514", 
                       "Whiten, Andrew. (2021). The Burgeoning Reach of Animal Culture."),
                tags$br(), tags$br(),
                "For the relevance of animal culture to conservation:",
                tags$br(),
                tags$a(href = "https://www.science.org/doi/abs/10.1126/science.aaw3557", 
                       "Brakes, Philippa, et al. (2019). Animal Cultures Matter for Conservation.")
              )
              
            ),
            
            # Question 5
            tags$div(
              style = "margin-bottom: 30px; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
              tags$h4(
                style = "font-size: 20px; font-weight: bold; color: #4CAF50; margin-bottom: 10px;",
                "Who can I contact for technical support?"
              ),
              tags$p(
                style = "text-align: justify; margin: 0;",
                "Please contact",
                tags$a(href = "mailto:cromanpa@arizona.edu", "Dr. Román-Palacios.")
              )
            )
          )
        )
      )
    )
  )
