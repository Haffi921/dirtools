#' Tools for directory management
#'
#' @keywords get working directory active document path

get_path <- function() {
	## We need two solutions:
	### One when user is using rStudio
	### and one where the user is not using rStudio
	isRStudio <- Sys.getenv("RSTUDIO") == 1

	if(isRStudio) {
		## This function needs the rStudioAPI package to run
		if(!requireNamespace("rstudioapi", quietly = TRUE)) {
			stop("Package \"rstudioapi\" needed for this function to work in RStudio.
					 Please install it.",
					 call. = FALSE)
		}
		tryCatch(rstudioapi::getSourceEditorContext()$path, error = function(e) {getwd()})
	}
	else {
		# Script
		if(!interactive()) {
			gsub("[~+~]+", " ", sub(".*=", "", commandArgs()[4]))
		}
		# Terminal/CMD Console
		else {
			getwd()
		}
	}
}

get_this_path <- function() {
	isRStudio <- Sys.getenv("RSTUDIO") == 1
	this_path <- list("path" = "", "filename" = NA)

	if(isRStudio) {
		## This function needs the rStudioAPI package to run
		if(!requireNamespace("rstudioapi", quietly = TRUE)) {
			stop("Package \"rstudioapi\" needed for this function to work in RStudio.
					 Please install it.",
					 call. = FALSE)
		}

		tryCatch(path <- rstudioapi::getSourceEditorContext()$path, error = function(e) {break()})

		this_path$path <- dirname(path = path)
		this_path$filename <- basename(path = path)
	}
	else if(!interactive()) {
		path <- gsub("[~+~]+", " ", sub(".*=", "", commandArgs()[4]))
		this_path$path <- dirname(path = path)
		this_path$filename <- basename(path = path)
	}
	else {
		this_path$path <- getwd()
	}

	this_path
}
