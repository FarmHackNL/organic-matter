library(lubridate)
library(dplyr)
library(shiny)
library(readr)
library(ggplot2)
library(ggthemes)
library(feather)
library(RColorBrewer)
library(purrr)

data_BG <- read_feather("data/bodemscan/bodemscan.feather")
# read_feather("shiny/data/bodemscan/bodemscan.feather")

data_p  <- read_feather("data/opbrengst/puma.feather")
# data_p2 <- read_feather("data/opbrengst/puma2.feather")
# data_p3 <- read_feather("data/opbrengst/puma3.feather")
names(data_p)[7]  <- "Lon"
names(data_p)[8]  <- "Lat"

# How the data was combined from the raw data:
# 
#### BODEM GELEIDBAARHEID ####
# 
# Please add all the bodemscan together in a folder, and do the same for opbrengst.
#
# # Read directories and csv file 
# dirs <- list.dirs("shiny/data/bodemscan")[seq(2,230, by = 2)]
# name <- substring(dirs, 32)
# date <- ymd(substring(dirs, 16, 23))
# csv  <- vector(mode="character", length=length(dirs))
# for(i in seq_along(dirs)) {
#   csv[i] <- list.files(dirs[i], pattern = ".csv")
# }
# dirs_csv <- paste0(dirs, "/", csv)
# 
# lijst <- data_frame(id = seq_along(dirs), 
#                     dirs = dirs, 
#                     name = name, 
#                     date = date,
#                     csv  = csv,
#                     dirs_csv = dirs_csv)
# 
# # Combine all the data together
# df <- tbl_df(read_csv(lijst$dirs_csv[1]))
# df$name <- lijst$name[1]
# for(i in seq_along(lijst$id)[-1]) {
#   add <- tbl_df(read_csv(lijst$dirs_csv[i]))
#   add$name <- lijst$name[i]
#   df <- bind_rows(df, add)
# }
# 
# write_feather(df, "data/bodemscan/bodemscan.feather")
# 
# ##### OPBRENGST #####
# 
# # Read directories and csv file 
# csv_puma2   <- list.files("data/opbrengst/puma+")
# csv_puma3   <- list.files("data/opbrengst/puma3")
# names_puma2 <- gsub(substring(csv_puma2, 24), pattern = ".csv", replacement = "")
# names_puma3 <- gsub(substring(csv_puma3, 24), pattern = ".csv", replacement = "")
# date_puma2  <- ymd(substring(csv_puma2, 8, 15))
# date_puma3  <- ymd(substring(csv_puma3, 8, 15)) 
# 
# dirs_puma2 <- "data/opbrengst/puma+/"
# dirs_puma3 <- "data/opbrengst/puma3/"
# 
# lijst_puma2 <- list(id = seq_along(csv_puma2), 
#                     name = names_puma2, 
#                     date = date_puma2,
#                     csv  = csv_puma2,
#                     df   = replicate(length(csv_puma2), data_frame()))
# lijst_puma3 <- list(id = seq_along(csv_puma3), 
#                     name = names_puma3, 
#                     date = date_puma3,
#                     csv  = csv_puma3,
#                     df   = replicate(length(csv_puma3), data_frame()))
# df_puma2 <- map(lijst_puma2$csv, function(x) tbl_df(read_csv(paste0(dirs_puma2, x))))
# df_puma3 <- map(lijst_puma3$csv, function(x) tbl_df(read_csv(paste0(dirs_puma3, x))))
# 
# # Remove data from bad sheets
# DF_puma2 <- df_puma2[map_dbl(df_puma2, function(x) dim(x)[2]) == 33]
# DF_puma3 <- df_puma3
# map_dbl(df_puma3, function(x) dim(x)[2] == 27)
# 
# # map_chr(DF_puma2, function(x) class(x[[17]]))
# DF_puma2[[33]][17] <- as.numeric(replicate(732, 3.72943))
# 
# names_p2 <- lijst_puma2$name[map_dbl(df_puma2, function(x) dim(x)[2]) == 33]
# names_p3 <- lijst_puma3$name
# date_p2 <- lijst_puma2$date
# date_p3 <- lijst_puma3$date
# 
# # Build puma+
# DF_p2 <- select(DF_puma2[[1]], c(1:8, 20))
# DF_p2$names <- names_p2[1]
# for(i in seq_along(DF_puma2)[-1]) {
#   add <- select(DF_puma2[[i]], c(1:8, 20))
#   add$names <- names_p2[i]
#   DF_p2 <- bind_rows(DF_p2, add)
# }
# names(DF_p2) <- c(names(DF_p2)[1:8], "yield", "names")
# 
# 
# DF_p3 <- select(DF_puma3[[1]], c(1:8, 20))
# DF_p3$names <- names_p3[1]
# for(i in seq_along(DF_puma3)[-1]) {
#   add <- select(DF_puma3[[i]], c(1:8, 20))
#   add$names <- names_p3[i]
#   DF_p3 <- bind_rows(DF_p3, add)
# }
# names(DF_p3) <- c(names(DF_p3)[1:8], "yield", "names")
# 
# write_feather(DF_p2, "data/opbrengst/puma2.feather")
# write_feather(DF_p3, "data/opbrengst/puma3.feather")
# 
# data_p2 <- read_feather("data/opbrengst/puma2.feather")
# data_p3 <- read_feather("data/opbrengst/puma3.feather")
# 
# data_p2$puma <- 2
# data_p3$puma <- 3
# 
# data_p <- bind_rows(data_p2, data_p3)
# data_p$puma <- factor(data_p$puma)
# 
# write_feather(data_p, "data/opbrengst/puma.feather")
