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
			path <- path.expand(rstudioapi::getSourceEditorContext()$path)

			dir <- dirname(path)
			filename <- basename(path)
			},
			silent = TRUE
		)
	}
	## Check if this is a script
	else if(!interactive()) {
		# Path of current console
		cmd <- switch(Sys.info()[['sysname']],
									Windows = shell("cd", intern = T),
									Linux = ,
									Darwin = system("pwd", intern = T),
									{
										stop("Could not determine ")
									}
		)

		# Path of current script from console
		path_from_cmd <- gsub("[~+~]+", " ", sub(".*=", "", commandArgs()[4]))


		if(substr(path_from_cmd, 1, nchar(cmd)) != cmd && cmd != "/") {
			path <- paste(cmd, path_from_cmd, sep = "/")
		} else if(substr(path_from_cmd, 1, nchar(cmd)) != cmd) {
			path <- paste(cmd, path_from_cmd, sep = "")
		} else {
			path <- path_from_cmd
		}

		path <- normalizePath(path)

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
