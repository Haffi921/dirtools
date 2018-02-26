#' Tools for directory management
#'
#' @keywords get working directory active document path

get_this_path <- function() {
	this_path <- list("dir" = "", "filename" = NA)

	## If function is called in a Terminal/CMD console
	## or in RStudio console with no open document,
	## path defaults to current working directory
	dir <- getwd()
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
			path <- rstudioapi::getSourceEditorContext()$path

			dir <- dirname(path)
			filename <- basename(path)
			},
			silent = TRUE
		)
	}
	## Check if this is a script
	else if(!interactive()) {
		# Path of current script
		path <- gsub("[~+~]+", " ", sub(".*=", "", commandArgs()[4]))

		if(dirname(path) == ".") {
			path <- paste(getwd(), basename(path), sep = "/")
		}

		dir <- dirname(path)
		filename <- basename(path)
	}

	this_path$dir <- dir
	this_path$filename <- filename

	this_path
}

get_this_dir <- function() {
	dir <- get_this_path()$dir

	if(dir == "") {
		stop("Directory not found.", call. = FALSE)
	}

	dir
}

get_this_filename <- function() {
	filename <- get_this_path()$filename

	if(is.na(filename)) {
		stop("This is not a file.", call. = FALSE)
	}

	filename
}
