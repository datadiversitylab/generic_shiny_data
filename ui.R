###################
# ui.R
# 
# UI controller. 
# Used to define the graphical aspects of the app.
###################

ui <- 
  navbarPage(
    id = "tabs",
    theme = bs_theme(bootswatch = "cosmo",
                     primary = "#4CAF50",
                     secondary = "#555555",
                     base_font = font_google("Roboto")  # Use a modern Google font
    ),
    div(
      tags$img(src = "DDL logo_white.png", style = "height: 40px; margin-right: 10px;"),
      style = "font-size: 24px; font-weight: bold; padding: 0 20px;",
      "The Animal Culture Database"
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
              "Animal Culture Database (ACDB)"
            ),
            tags$h2(
              style = "font-size: 24px; font-weight: 300; text-align: center; color: #555555; margin-bottom: 40px;",
              "Exploring the World’s Diversity of Nonhuman Animal Traditions"
            ),
            
            # Introduction text
            tags$p(
              style = "text-align: justify; margin-bottom: 15px;",
              " In hac habitasse platea dictumst. Interdum et malesuada fames ac ante ipsum primis in faucibus. Aliquam luctus, ipsum quis posuere aliquam, justo felis eleifend arcu, quis vehicula ligula diam in massa. Sed sed nisl et tellus iaculis vulputate at eget quam. Duis sed tortor tellus. Aenean lacus neque, congue sit amet ligula id, condimentum accumsan justo. Nunc eu cursus massa, in dictum orci. Phasellus a erat in dui consectetur dapibus. "
            ),
            tags$p(
              style = "text-align: justify; margin-bottom: 15px;",
              " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam finibus feugiat justo, non efficitur augue fringilla id. Donec at elit blandit, faucibus nisi eu, posuere turpis. Aenean dapibus odio eu diam euismod, vel interdum elit pulvinar. Vivamus at lorem a neque hendrerit sollicitudin. Donec at suscipit neque. Integer eget gravida lacus. Maecenas luctus dapibus hendrerit. Integer vel metus sed diam volutpat sagittis. Aliquam eu convallis tellus. Ut hendrerit ut mauris accumsan egestas. Vivamus iaculis ut mauris sed eleifend. "
            ),
            tags$p(
              style = "text-align: justify; margin-bottom: 15px;",
              " Sed pretium eros sit amet magna scelerisque, non posuere elit placerat. Pellentesque consectetur neque massa, nec commodo nisl convallis vel. Aliquam in pellentesque elit. Nulla bibendum rhoncus libero vitae viverra. Vivamus tincidunt enim a turpis scelerisque interdum. Nunc ullamcorper lacinia nulla, vitae tempus magna ultrices ut. Quisque bibendum viverra nisi ut mollis. Donec accumsan massa leo, non fringilla eros malesuada eu. Donec convallis justo vel commodo vulputate. "
            ),
            tags$div(
              style = "text-align: center;",
              actionButton(inputId = "explore_button", 
                           label = "Explore the Database",
                           style = "display:inline-block; padding: 15px 30px; border-radius: 5px; background: #4CAF50; color: #ffffff; text-decoration: none; font-size: 18px; font-weight: 400; transition: background 0.3s ease;")
              
            )
          ),
          
          # Quick Stats Section 
          tags$div(
            style = "margin-top: 40px; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
            tags$h3(
              style = "font-size: 24px; font-weight: bold; color: #4CAF50; text-align: center; margin-bottom: 20px;",
              "Quick Stats"
            ),
            tags$div(
              style = "display: flex; justify-content: space-around; text-align: center;",
              
              # Species covered
              tags$div(
                tags$h4(style = "font-size: 20px; font-weight: bold; color: #333;", uiOutput("species_count")),
                tags$p(style = "font-size: 16px; color: #555;", "Species covered")
              ),
              
              # Behaviors documented
              tags$div(
                tags$h4(style = "font-size: 20px; font-weight: bold; color: #333;", uiOutput("behavior_count")),
                tags$p(style = "font-size: 16px; color: #555;", "Behaviors documented")
              ),
              
              # Populations cataloged
              tags$div(
                tags$h4(style = "font-size: 20px; font-weight: bold; color: #333;", uiOutput("population_count")),
                tags$p(style = "font-size: 16px; color: #555;", "Populations cataloged")
              )
            )
          )
          
        )
      )
    )
    ,
    
    # Populations page
    tabPanel(
      value = "Populations_tab",
      tags$div(icon("globe"), "Populations"),
      fluidPage(
        #titlePanel("Populations"),
        tags$div(
          style = "max-width: 900px; margin: 0 auto; padding: 20px 0; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: #333333; line-height: 1.8;",
          
          tags$div(
            style = "background-color: #f9f9f9; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
            
            # Introduction section
            tags$h3(
              style = "font-size: 24px; font-weight: bold; color: #4CAF50; text-align: center; margin-bottom: 20px;",
              "Explore population-level data"
            ),
            tags$p(
              style = "text-align: justify; margin-bottom: 15px;",
              " In non nulla sed neque pellentesque semper ut quis odio. Nulla pellentesque ante arcu, sit amet aliquam lectus aliquam at. Nunc semper quam eu ex eleifend, ut tempor lacus aliquam. Quisque at libero ipsum. Aliquam erat volutpat. Phasellus libero nulla, ultricies id aliquam id, sodales sit amet odio. Maecenas luctus sit amet ex eu faucibus. Sed blandit, tortor sed dignissim rutrum, lorem est congue elit, vitae dapibus nunc diam vitae metus. In sed tortor non ante laoreet laoreet. Cras vel tellus euismod, iaculis orci fringilla, efficitur dolor. Sed egestas ultrices accumsan. "
            ),
            tags$p(
              style = "text-align: justify; margin-bottom: 15px;",
              " Vestibulum et erat at mauris ornare feugiat. Vivamus vitae augue ac neque congue egestas sed nec turpis. Nam dolor nunc, aliquam venenatis interdum mattis, luctus in velit. Nulla facilisi. Nullam interdum diam vel lobortis bibendum. Nulla ut sem elit. In at sapien fringilla, auctor elit ac, vulputate ante. Maecenas viverra consectetur venenatis. Cras eu dapibus augue, ut pretium quam. Sed commodo lacinia lacus accumsan mollis. Fusce imperdiet ligula eros, vitae pellentesque mauris convallis eu. Vestibulum facilisis purus in risus cursus, vitae eleifend mi consequat. "
            ),
            tags$p(
              style = "text-align: justify; margin-bottom: 0;",
              " Nunc placerat blandit enim, ac convallis magna pharetra at. Donec quis ornare mi, hendrerit tristique eros. Curabitur ultrices ultricies ornare. Suspendisse potenti. Cras iaculis turpis eget arcu pretium feugiat. Pellentesque condimentum lorem quis facilisis sollicitudin. Nulla eu lacus elementum, scelerisque quam non, condimentum turpis. Nunc at lectus at quam varius feugiat vitae ac ante. In suscipit sagittis augue accumsan maximus. Sed et elit et mi laoreet efficitur id quis neque. "
            )
          )
        ),
        
        # Map and Table Section
        tags$div(
          style = "max-width: 1100px; margin: 40px auto;",
          
          # Map with a shadow effect
          tags$div(
            style = "background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); margin-bottom: 40px;",
            tags$h4(
              style = "font-size: 20px; font-weight: bold; color: #4CAF50; margin-bottom: 15px;",
              "Interactive Map"
            ),
            tags$p(
              style = "margin-bottom: 10px;",
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris ullamcorper risus massa, quis facilisis augue vehicula ut. Pellentesque posuere porta luctus. Integer massa erat, imperdiet non pharetra nec, tempus eget. "
            ),
            leafletOutput("population_map", height = 400)
            
          ),
          
          # Table with a shadow effect
          tags$div(
            style = "background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
            tags$h4(
              style = "font-size: 20px; font-weight: bold; color: #4CAF50; margin-bottom: 15px;",
              "Population Data Table"
            ),
            tags$p(
              style = "margin-bottom: 10px;",
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean non nunc vitae augue convallis maximus ut sit amet augue. Nunc egestas, dolor in cursus ultrices, enim diam fermentum diam, sed. "
            ),
            dataTableOutput("groups_table")
          )
        )
      )
    ),
    
    # Help tab
    tabPanel(
      tags$div(icon("question-circle"), "Help"),
      fluidPage(
        tags$div(
          style = "max-width: 900px; margin: 0 auto; padding: 40px 20px; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; color: #333333; line-height: 1.8;",
          
          # Help Introduction
          tags$div(
            style = "background-color: #f9f9f9; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
            tags$h1(
              style = "font-size: 36px; font-weight: bold; text-align: center; color: #4CAF50; margin-bottom: 20px;",
              "Help and FAQs"
            ),
            tags$p(
              style = "text-align: center; color: #555555; margin-bottom: 40px;",
              " Nunc sodales libero et tortor interdum, nec viverra libero cursus. In lobortis ligula quam, vitae ultrices neque aliquam sed. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nunc sapien neque, faucibus in rutrum id, dignissim ut turpis. Pellentesque gravida mauris non convallis tristique. Mauris vel cursus nisi, in pretium neque. In hendrerit est eget sodales varius. "
            )
          ),
          
          # FAQ Sections
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
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec quis felis ac felis efficitur suscipit. Curabitur vitae lacus vel ligula aliquet dignissim quis eget lacus."
              )
            ),
            
            # Question 2
            tags$div(
              style = "margin-bottom: 30px; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
              tags$h4(
                style = "font-size: 20px; font-weight: bold; color: #4CAF50; margin-bottom: 10px;",
                "How can I contribute data to the database?"
              ),
              tags$p(
                style = "text-align: justify; margin: 0;",
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent interdum, nisl eu interdum aliquet, felis nulla sollicitudin elit, in faucibus risus urna vel justo."
              )
            ),
            
            # Question 3
            tags$div(
              style = "margin-bottom: 30px; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
              tags$h4(
                style = "font-size: 20px; font-weight: bold; color: #4CAF50; margin-bottom: 10px;",
                "Where can I learn more about animal culture?"
              ),
              tags$p(
                style = "text-align: justify; margin: 0;",
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam ullamcorper enim nec justo congue, ac cursus mauris aliquet. Pellentesque habitant morbi tristique senectus et netus."
              )
            ),
            
            # Question 4
            tags$div(
              style = "margin-bottom: 30px; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);",
              tags$h4(
                style = "font-size: 20px; font-weight: bold; color: #4CAF50; margin-bottom: 10px;",
                "Who can I contact for technical support?"
              ),
              tags$p(
                style = "text-align: justify; margin: 0;",
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer non nisi erat. Fusce faucibus purus in magna vehicula consequat. Aliquam tempus vitae libero et laoreet."
              )
            )
          )
        )
      )
    )
  )
