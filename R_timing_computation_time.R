# benchmarking processing times in R
library(data.table)
library(dplyr)
library(plyr)

# timing function
time <- function(...) {
  time_measurement <- system.time(eval(...))
  time_measurement[["user.self"]]
}

# run same code n times to get min / max / mean runtimes
benchmark <- function(..., n = 100) {
  times <- replicate(n, ...)
  c(min = min(times), max = max(times), mean = mean(times))
}


# timing my slow join (3 seconds on average)
time(merge(x = final, y = mapping[, c("SepaCreditorName","SepaCreditorIBAN", "trCategory")], by = c("SepaCreditorName","SepaCreditorIBAN"), all.x = TRUE)
)

# set index key on data tables to see whether there's room for improvement (1k rows)
setkey(mapping, SepaCreditorIBAN, SepaCreditorName)
mapping <- as.data.table(mapping)
key(mapping)

# set index on final (120k rows)
setkey(final, SepaCreditorIBAN, SepaCreditorName)
final <- as.data.table(final)
key(final)

# get benchmarked times - 0.2 seconds on average after indexes
benchmark({
  time(final2 <- merge(x = final, y = mapping[, c("SepaCreditorName","SepaCreditorIBAN", "trCategory")], by = c("SepaCreditorName","SepaCreditorIBAN"), all.x = TRUE)
  )
})
