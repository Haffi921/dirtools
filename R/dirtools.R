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

		print("isRStudio = TRUE")

		if(rstudioapi::getActiveDocumentContext()$path == "") {
			switch (Sys.info()[['sysname']],
				Windows = shell("cd", intern = T),
				Linux = ,
				Darwin = {system("pwd", intern = T)},
				{
					stop("Could not determine operating system.",
							 call. = FALSE)
				}
			)
			print("RStudio console")
		}
		else {
			rstudioapi::getActiveDocumentContext()$path
			print("RStudio script")
		}
	}
	else {
		if(!interactive()) {
			sub(".*=", "", commandArgs()[4])

			print("Script")
		}
		else {
			if(!requireNamespace("here", quietly = TRUE)) {
				stop("Package \"here\" needed for this function to work in Terminal (Mac/Linux) and CMD (Windows)
						 Please install it.",
						 call. = FALSE)
			}
			here::here()

			print("Terminal/CMD Console")
		}
	}
}
