#' Tools for directory management
#'
#' @keywords get working directory active document path

get_this_path <- function() {
	this_path <- list("path" = "", "filename" = NA)

	## If function is called in a Terminal/CMD console
	## or in RStudio console with no open document,
	## path defaults to current working directory
	path <- getwd()
	filename <- NA

	isRStudio <- Sys.getenv("RSTUDIO") == 1

	## We need two solutions:
	### One when user is using rStudio
	### and one where the user is not using rStudio
	if(isRStudio) {
		## This function needs the rStudioAPI package to run
		if(!requireNamespace("rstudioapi", quietly = TRUE)) {
			stop("Package \"rstudioapi\" needed for this function to work in RStudio.
					 Please install it.",
					 call. = FALSE)
		}

		## If a document is open in RStudio this runs
		try({
			# Path of current open document or script that function is called in
			temp_path <- rstudioapi::getSourceEditorContext()$path

			path <- dirname(temp_path)
			filename <- basename(temp_path)
			},
			silent = TRUE
		)
	}
	## Check if this is a script
	else if(!interactive()) {
		# Path of current script
		temp_path <- gsub("[~+~]+", " ", sub(".*=", "", commandArgs()[4]))

		path <- dirname(temp_path)
		filename <- basename(temp_path)
	}

	this_path$path <- path
	this_path$filename <- filename

	this_path
}

get_this_filename <- function() {
	filename <- get_this_path()$filename

	if(is.na(filename)) {
		stop("This is not a file.", call. = FALSE)
	}
	else {
		filename
	}
}
