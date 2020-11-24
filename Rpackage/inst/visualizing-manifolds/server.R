
library(shiny)

dr_demo <- function(sim_data, algor, k, d=2, kernel = 'rbfdot') {
    if (is.null(algor) | is.null(sim_data) | is.null(k) | is.null(d)) return(NULL)
    if (is.na(algor)) return(NULL)
    algor <- toupper(algor)
    
    run_time <- proc.time()
    proj_data <- switch(
        algor,
        PCA = {
            pca_dr <- sim_data$data %>% center_and_standardise() %>% prcomp()
            sim_data$data %*% pca_dr$rotation[,1:2] 
            },
        MDS = cmdscale(dist(sim_data$data), k = d),
        ISOMAP = RDRToolbox::Isomap(sim_data$data, dims = d, k = k)$dim2,
        LLE = LLE2(sim_data$data, dim = d, k = k),
        DIFFUSIONMAP = diffusionMap::diffuse(dist(sim_data$data), neigen = d)$X,
        TSNE = tsne::tsne(sim_data$data, k = d),
        KPCA = kernlab::kpca(sim_data$data, kernel = kernel, features = d)@pcv,
        SPE = spe::spe(sim_data$data, edim = d)$x,
        LE = Laplacian_Eigenmaps(sim_data$data, k = k, d = d)$eigenvectors,
        HLLE = Hessian_LLE(sim_data$data, k = k, d = d)$projection,
        LTSA = Local_TSA(sim_data$data, k = k, d = d)
        )
    run_time = proc.time() - run_time
    
    
    p1 <- plotly_2D(proj_data, sim_data$colors)
    plot_title <- paste(algor, ". Time taken: ", 
                        round(run_time[[1]], 3), "s.", sep = "")
    p1 <- layout(p1, title = plot_title)
    list(p1, run_time)
}


server <- shinyServer(function(input, output) {
    data_from_file <- reactive({
        inFile <- input$file_input
        if (is.null(inFile)) return(NULL)
        sim_data <- load( inFile$datapath)
        if (ncol(sim_data) >= 4) {
            scale <- sim_data[,4]
        } else {
            scale <- z
        }
        list(data = as.matrix(sim_data), colors = scale)
    })
    
    reduce_to_3d <- reactive({
        sim_data <- data_from_file()
        sim_data$data <- sim_data$data[,1:3]
        sim_data
    })
    
    DR_data <- reactiveValues(simulation = NULL)
    total_time <- reactiveValues(time_taken = NULL)
    
    output$ui <- renderUI({
        data_param_label <- switch(input$data_input,
                                   "Swiss Roll" = "Height",
                                   "Swiss Hole" = "Height",
                                   "Corner Planes" = "Angles",
                                   "Punctured Sphere" = "Z scale",
                                   "Twin Peaks" = "Z scale",
                                   "Clusters" = "Number of clusters",
                                   "Toroidal Helix" = "Sample rate",
                                   "Gaussian" = "Sigma")
        initial_value <- switch(input$data_input,
                                "Swiss Roll" = 1,
                                "Swiss Hole" = 1,
                                "Corner Planes" = 45,
                                "Punctured Sphere" = 1,
                                "Twin Peaks" = 1,
                                "Clusters" = 3,
                                "Toroidal Helix" = 1,
                                "Gaussian" = 1)
        numericInput("data_parameter", data_param_label, value = initial_value)
    })
    

    output$plot_3d <- renderPlotly({
        if (!is.null(data_from_file())) {
            sim_data <- reduce_to_3d()
        } else {
            data_f <- switch(input$data_input,
                             "Swiss Roll" = swiss_roll,
                             "Swiss Hole" = swiss_hole,
                             "Corner Planes" = corner_planes,
                             "Punctured Sphere" = punctured_sphere,
                             "Twin Peaks" = twin_peaks,
                             "Clusters" = clusters_3d,
                             "Toroidal Helix" = toroidal_helix,
                             "Gaussian" = gaussian_random_samples)
            sim_data <- data_f(input$num_pts, input$data_parameter)
            DR_data$simulation <- sim_data
        }
        if (is.null(sim_data$data) | (ncol(sim_data$data) < 3)) {
            plotly_empty(type = "scatter", mode = "markers")
        } else {
            plotly_3D(sim_data)
        }
    })
    
    output$plot_2d <- renderPlotly({
        if (!is.null(data_from_file())) {
            sim_data <- data_from_file()
            DR_data$simulation <- sim_data
        }
        if (is.null(DR_data$simulation) | (ncol(DR_data$simulation$data) < 3)) {
            plotly_empty(type = "scatter", mode = "markers")
        } else {
            res <- dr_demo(DR_data$simulation, algor = input$algor,
                           k = input$k, d = 2, kernel = input$kernel)
            total_time$time_taken <- res[[2]]
            res[[1]]
        }
    })
    
    output$file_text <- renderText({"Only plots the first 3 dimensions of the data.
     The 4th dimension is used as colors if available; otherwise, the 3rd dimension is used."})
    output$comment_text <- renderText({"The target dimension is fixed at 2."})
    output$plot_text <- renderPrint({
        cat("Time taken:", total_time$time_taken[[1]], "s. \n")
    })
})
