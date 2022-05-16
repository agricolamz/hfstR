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
  recompile(path)
  lookup(path, get_goal(path))
}
