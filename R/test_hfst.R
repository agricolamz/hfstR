#' Test the results
#'
#' Use ***_test.csv for checking results of hfst.
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @param path character with the path to the `Makefile`
#' @return a vector of strings with output of `hfst-fst2strings`
#' @export

run_tests <- function(path){
  path <- normalizePath(path)
  recompile(path)
  df <- read.csv(list.files(path, pattern = "tests.csv", full.names = TRUE))
  results <- unlist(lapply(df$form, function(i){
    system(paste0("echo '",
                  i,
                  "' | hfst-lookup ",
                  paste0(path, "/", get_goal(path))),
           intern = TRUE,
           ignore.stderr = TRUE)
  }))
  results <- read.table(text = results[results != ""], sep = "\t")
  analyser_check <- cbind(data.frame(observed = results$V2), df)
  analyser_check <- analyser_check[analyser_check$observed !=
                                     analyser_check$analysis,]
  analyser_check$expected <- analyser_check$analysis

  results <- unlist(lapply(df$analysis, function(i){
    system(paste0("echo '",
                  i,
                  "' | hfst-lookup ",
                  paste0(path, "/",
                         gsub("analizer", "generator", get_goal(path)))),
           intern = TRUE,
           ignore.stderr = TRUE)
  }))

  results <- read.table(text = results[results != ""], sep = "\t")
  generator_check <- cbind(data.frame(observed = results$V2), df)
  generator_check <- generator_check[generator_check$observed !=
                                 generator_check$form,]
  generator_check$expected <- generator_check$form
  final_result <- rbind(generator_check, analyser_check)
  rownames(final_result) <- 1:nrow(final_result)
  cn <- which(!(colnames(final_result) %in% c("observed", "expected", "analysis", "form")))
  cbind(final_result[,c("observed", "expected")], final_result[,cn])
}
