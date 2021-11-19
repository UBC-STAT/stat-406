install_miniconda <- function(path = reticulate::miniconda_path(),
                              update = TRUE,
                              force = FALSE) {
  tag  <- installation_target_tag()
  tested_combo <- tested_installation_combos[tag, ]
  if (is.na(tested_combo$os)) {
    stop(sprintf("install_miniconda: Unknown target %s.", tag))
  }
  
  reticulate:::check_forbidden_install("Miniconda")
  
  if (grepl(" ", path, fixed = TRUE))
    stop("cannot install Miniconda into a path containing spaces")
  
  # TODO: what behavior when miniconda is already installed?
  # fail? validate installed and matches request? reinstall?
  reticulate:::install_miniconda_preflight(path, force)
  
  # download the installer
  url <- miniconda_installer_url()
  installer <- reticulate:::miniconda_installer_download(url)
  
  # run the installer
  message("* Installing Miniconda -- please wait a moment ...")
  reticulate:::miniconda_installer_run(installer, path = path, update = update)
  
  # validate the install succeeded
  ok <- reticulate:::miniconda_exists(path) && reticulate:::miniconda_test(path)
  if (!ok)
    stop("Miniconda installation failed [unknown reason]")
  
  # update to latest version if requested
  if (update)
    reticulate::miniconda_update(path)
  
  conda <- reticulate:::miniconda_conda(path)
  # create r-reticulate environment
  # just basic stuff for now
  py_pkgs <- c(
    paste0("python==", tested_combo$python),
    paste0("pillow==", tested_combo$pillow),
    paste0("numpy==", tested_combo$numpy),
    paste0("scipy==", tested_combo$scipy)
  )
  
  reticulate::conda_create(envname = "r-reticulate",
                           packages = py_pkgs,
                           conda = conda,
                           python_version = tested_combo$python
  )
  message(sprintf("* Miniconda has been successfully installed at %s.", shQuote(path)))
  path
  
}
