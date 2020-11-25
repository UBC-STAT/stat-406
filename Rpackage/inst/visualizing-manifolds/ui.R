
library(shiny)
library(plotly)
library(maniTools)


# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
    # Application title
    titlePanel("Manifold learning in R"),
    
    fluidRow(
        column(6,
               wellPanel(
                   style = "background-color: #002145; color: #dddddd",
                   h3("Data source"),
                   fluidRow(
                       column(4,
                              selectInput(
                                  "data_input", "Examples",
                                  choice = c("Swiss Roll", "Swiss Hole", 
                                             "Corner Planes",
                                             "Punctured Sphere", "Twin Peaks", 
                                             "Clusters", "Toroidal Helix", 
                                             "Gaussian"), 
                                  selected = "Swiss Roll")
                       ),
                       column(4, numericInput("num_pts", "#Points", 800)),
                       column(4, uiOutput("ui"))
                   ),
                   hr(),
                   fluidRow(
                       column(8, fileInput("file_input", "Upload .RDS File", 
                                           accept = c('.rds'))
                       )
                   ),
                   textOutput("file_text")
                   #submitButton("Load Example")
               ),
               
               wellPanel(
                   style = "background-color: #6ec4e8;",
                   h3("Algorithm"),
                   fluidRow(
                       selectInput(
                           "algor", label = "", 
                           choices = list(
                               "MDS" = "mds", "PCA" = "pca", 
                               "Kernel PCA" = "kpca",
                               "ISOMAP" = "isomap", 
                               "Diffusion Map" = "diffusionMap",
                               "Laplacian Eigenmaps" = "le", 
                               "Locally Linear Embedding (LLE)" = "lle",
                               "Hessian-LLE (HLLE)" = "hlle", "t-SNE" = "tsne",
                               "Stochastic Proximity Embedding (SPE)" = "spe",
                               "Local Tangent Space Alignment (LTSA)" = "ltsa")
                           )
                   ),
                   textOutput("plot_text")
               ),
               wellPanel(
                   style = "background-color: #6ec4e8;",
                   h3("Some Parameters"),
                   p("for some algorithms"),
                   fluidRow(
                       column(6, 
                              numericInput(
                                  "k", "# Nearest Neighbors", 8, min = 1)),
                       column(6, 
                              selectInput("kernel", "Kernel",
                                          choices = c("rbfdot", "polydot", 
                                                      "vanilladot", "tanhdot", 
                                                      "splinedot")
                                          ))
                   ),
                   textOutput("comment_text")
               )
        ),
        column(6,
               plotlyOutput("plot_3d"),
               plotlyOutput("plot_2d")
        )
    )
)
)




