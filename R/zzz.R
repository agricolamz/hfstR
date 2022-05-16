#' Get goal of the map file
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @noRd

get_goal <- function(path){
  path <- normalizePath(path)
  makefile <- readLines(paste0(path, "/Makefile"))
  line <- makefile[grep(".DEFAULT_GOAL", makefile)]
  goal <- unlist(strsplit(line, " "))
  goal[length(goal)]
}

#' Run `Makefile` in order to recompile everything
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @noRd

recompile <- function(path){
  path <- normalizePath(path)
  system(paste0("cd ", path, "; make"), ignore.stdout = TRUE)
}

#' Create a lookup
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @noRd

lookup <- function(path, goal){
  path <- normalizePath(path)
  system(paste0("cd ",
                path,
                "; hfst-fst2strings ",
                goal),
         intern = TRUE)
}

