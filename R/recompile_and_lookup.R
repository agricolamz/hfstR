#' Recompile and lookup
#'
#' Run `make` in the folder that recompiles `.hfst` from `.lexd` and run `hfst-fst2strings` afterwards.
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @param path character with the path to the `Makefile`
#' @return a vector of strings with output of `hfst-fst2strings`
#' @export

recompile_and_lookup <- function(path){
  path <- normalizePath(path)
  makefile <- readLines(paste0(path, "/Makefile"))
  line <- makefile[grep(".DEFAULT_GOAL", makefile)]
  goal <- unlist(strsplit(line, " "))
  goal <- goal[length(goal)]
  tmp <- tempfile(fileext = ".txt")
  system(paste0("cd ",
                path,
                "; make; hfst-fst2strings ",
                goal,
                " > ",
                tmp))
  readLines(tmp)
}
