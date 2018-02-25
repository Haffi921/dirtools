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
	path <- getwd()
	filename <- NA

	if(isRStudio) {
		## This function needs the rStudioAPI package to run
		if(!requireNamespace("rstudioapi", quietly = TRUE)) {
			stop("Package \"rstudioapi\" needed for this function to work in RStudio.
					 Please install it.",
					 call. = FALSE)
		}

		try({
			temp_path <- rstudioapi::getSourceEditorContext()$path
			path <- dirname(temp_path)
			filename <- basename(temp_path)
			print("Tried this")
		})
		print("RStudio")
	}
	else if(!interactive()) {
		temp_path <- gsub("[~+~]+", " ", sub(".*=", "", commandArgs()[4]))
		path <- dirname(temp_path)
		filename <- basename(temp_path)
	}

	this_path$path <- path
	this_path$filename <- filename

	this_path
}
