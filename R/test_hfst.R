#' Test the results
#'
#' Use ***_test.csv for checking results of hfst.
#'
#' @author George Moroz <agricolamz@gmail.com>
#' @param path character with the path to the `Makefile`
#' @return a dataframe with differences between transducer and tests
#' @export

run_tests <- function(path){
  path <- normalizePath(path)
  recompile(path)
  df <- read.csv(list.files(path, pattern = "tests.csv", full.names = TRUE))

  results <- lapply(df$form, function(i){
    generated <- system(paste0("echo '",
                               i,
                               "' | hfst-lookup ",
                               paste0(path, "/", get_goal(path))),
                        intern = TRUE,
                        ignore.stderr = TRUE)
    suppressWarnings({cbind(read.table(text = generated, sep = "\t"),
                            df[df$form == i,])})
  })

  analyser_check <- Reduce(rbind, results)

  names(analyser_check)[names(analyser_check) == "V2"] <- "observed"
  analyser_check$expected <- analyser_check$analysis

  analyser_check$diff <- analyser_check$observed == analyser_check$analysis

  analyser_check <- analyser_check[analyser_check$form %in%
                                     analyser_check$form[!analyser_check$diff],]

  analyser_check <- subset(analyser_check, select = -c(V1, V3, form, analysis))

  results <- lapply(df$analysis, function(i){
    generated <- system(paste0("echo '",
                  i,
                  "' | hfst-lookup ",
                  paste0(path, "/",
                         gsub("analizer", "generator", get_goal(path)))),
           intern = TRUE,
           ignore.stderr = TRUE)
    suppressWarnings({cbind(read.table(text = generated, sep = "\t"),
                            df[df$analysis == i,])})
  })

  generator_check <- Reduce(rbind, results)

  names(generator_check)[names(generator_check) == "V2"] <- "observed"
  generator_check$expected <- generator_check$form

  generator_check$diff <- generator_check$observed == generator_check$form

  generator_check <- generator_check[generator_check$analysis %in%
                                       generator_check$analysis[!generator_check$diff],]

  generator_check <- subset(generator_check, select = -c(V1, V3, form, analysis))

  final_result <- rbind(generator_check, analyser_check)
  rownames(final_result) <- 1:nrow(final_result)
  cn <- which(!(colnames(final_result) %in% c("observed", "expected", "diff", "analysis", "form")))
  cbind(final_result[,c("observed", "expected", "diff")], final_result[,cn])
}
