library(ggplot2)
library(dplyr)
library(stargazer)
library(knitr)
library(lfe)


base_directory = getwd()
base_data_directory = paste0(base_directory, "/tweet_data/combined_data/")
plot_directory = paste0(base_directory, "/plots/")
BLM_combined_data_filepath = paste0(base_data_directory, "BLM_tweets.csv")
BTB_combined_data_filepath = paste0(base_data_directory, "BTB_tweets.csv")

pull_clean_data <- function(filepath){
  pulled_data = read.csv(filepath)
  pulled_data$tweet_category = as.factor(pulled_data$tweet_category)
  pulled_data$conversationId = as.character(pulled_data$conversationId)
  pulled_data$contains_hashtag = 0
  pulled_data[grepl("#", pulled_data$tweet_category), ]$contains_hashtag = 1
  pulled_data$date = as.POSIXct(pulled_data$date)
  pulled_data$Year_month_day = format(pulled_data$date, format = "%Y-%m-%d")
  return(pulled_data)
}

non_duplicates_data <- function(tweet_data){
  n_occur <- data.frame(table(tweet_data$conversationId))
  duplicates = n_occur[n_occur$Freq > 1,]
  
  non_duplicates = tweet_data[!(tweet_data$conversationId %in% duplicates$Var1),]
  duplicates = tweet_data[(tweet_data$conversationId %in% duplicates$Var1),]
  results = list(non_duplicates,duplicates)
  return(non_duplicates)
}

BLM_tweets = pull_clean_data(BLM_combined_data_filepath)
BTB_tweets = pull_clean_data(BTB_combined_data_filepath)

BLM_tweets$BLM = 1
BTB_tweets$BLM = 0

tweets_data = rbind(BLM_tweets,BTB_tweets)

nrow(tweets_data)

non_duplicates = non_duplicates_data(tweets_data)

head(non_duplicates)

nrow(non_duplicates[non_duplicates$BLM == 0,])

average_scores <- function(tweets) {
  treatment_category_results = tweets %>% group_by(treatment,
                                                   tweet_category) %>% summarise(
                                                     avg_replyCount = mean(replyCount),
                                                     avg_likeCount = mean(likeCount),
                                                     avg_quoteCount = mean(quoteCount),
                                                     avg_replyCount = mean(replyCount),
                                                     med_replyCount = median(replyCount),
                                                     med_likeCount = median(likeCount),
                                                     med_quoteCount = median(quoteCount),
                                                     med_replyCount = median(replyCount),
                                                     num_posts = n()
                                                   )
  treatment_category_hashtag = tweets %>% group_by(treatment,
                                                   contains_hashtag) %>% summarise(
                                                     avg_replyCount = mean(replyCount),
                                                     avg_likeCount = mean(likeCount),
                                                     avg_quoteCount = mean(quoteCount),
                                                     avg_replyCount = mean(replyCount),
                                                     med_replyCount = median(replyCount),
                                                     med_likeCount = median(likeCount),
                                                     med_quoteCount = median(quoteCount),
                                                     med_replyCount = median(replyCount),
                                                     num_posts = n()
                                                   )
  daily_contains_hashtag = tweets %>% group_by(Year_month_day,
                                               contains_hashtag) %>% summarise(
                                                 avg_replyCount = mean(replyCount),
                                                 avg_likeCount = mean(likeCount),
                                                 avg_quoteCount = mean(quoteCount),
                                                 avg_replyCount = mean(replyCount),
                                                 med_replyCount = median(replyCount),
                                                 med_likeCount = median(likeCount),
                                                 med_quoteCount = median(quoteCount),
                                                 med_replyCount = median(replyCount),
                                                 num_posts = n()
                                               )
  
  daily_by_category = tweets %>% group_by(Year_month_day,
                                          tweet_category) %>% summarise(
                                            avg_replyCount = mean(replyCount),
                                            avg_likeCount = mean(likeCount),
                                            avg_quoteCount = mean(quoteCount),
                                            avg_replyCount = mean(replyCount),
                                            med_replyCount = median(replyCount),
                                            med_likeCount = median(likeCount),
                                            med_quoteCount = median(quoteCount),
                                            med_replyCount = median(replyCount),
                                            num_posts = n()
                                          )
  
  treatment_has_hash_by_BLM = tweets %>% group_by(treatment,
                                          contains_hashtag,BLM) %>% summarise(
                                            avg_replyCount = mean(replyCount),
                                            avg_likeCount = mean(likeCount),
                                            avg_quoteCount = mean(quoteCount),
                                            avg_replyCount = mean(replyCount),
                                            med_replyCount = median(replyCount),
                                            med_likeCount = median(likeCount),
                                            med_quoteCount = median(quoteCount),
                                            med_replyCount = median(replyCount),
                                            num_posts = n()
                                          )
  daily_has_hash_by_BLM = tweets %>% group_by(Year_month_day,
                                                  contains_hashtag,BLM) %>% summarise(
                                                    avg_replyCount = mean(replyCount),
                                                    avg_likeCount = mean(likeCount),
                                                    avg_quoteCount = mean(quoteCount),
                                                    avg_replyCount = mean(replyCount),
                                                    med_replyCount = median(replyCount),
                                                    med_likeCount = median(likeCount),
                                                    med_quoteCount = median(quoteCount),
                                                    med_replyCount = median(replyCount),
                                                    num_posts = n()
                                                  )
  
  avg_results = list(
    treatment_category_results,
    treatment_category_hashtag,
    daily_contains_hashtag,
    daily_by_category,
    treatment_has_hash_by_BLM,
    daily_has_hash_by_BLM
  )
  return(avg_results)
}

r = average_scores(non_duplicates)

create_plots_for_tweet_category <- function(r, plot_directory,w,h,l_title) {
  treated_by_category_rc <- ggplot(r[[1]],
                                   aes(treatment, avg_replyCount))
  treated_by_category_rc + geom_line(aes(colour =
                                           factor(tweet_category)))
  
  treated_by_category_lc <- ggplot(r[[1]],
                                   aes(treatment, avg_likeCount))
  treated_by_category_lc + geom_line(aes(colour =
                                           factor(tweet_category)))
  
  treated_by_category_qc <- ggplot(r[[1]],
                                   aes(treatment, avg_quoteCount))
  treated_by_category_qc + geom_line(aes(colour =
                                           factor(tweet_category)))
  
  
  
  r[[1]]$treatment = as.factor(r[[1]]$treatment)
  
  treated_by_category_bar_plot_rc <-
    ggplot(r[[1]], aes(tweet_category,
                       avg_replyCount,
                       fill = treatment))
  treated_by_category_bar_plot_rc = treated_by_category_bar_plot_rc +
    geom_bar(stat = "identity", position = position_dodge())
  treated_by_category_bar_plot_rc  = treated_by_category_bar_plot_rc +
    labs(x = "\n Tweet Category",
         y = "Average Reply Count \n", 
         fill = l_title)
  filename = paste0(plot_directory, "rc_category_bp.pdf")
  ggsave(filename, treated_by_category_bar_plot_rc, width = w, height = h)
  
  
  treated_by_category_bar_plot_lc <-
    ggplot(r[[1]], aes(tweet_category,
                       avg_likeCount,
                       fill = treatment))
  treated_by_category_bar_plot_lc = treated_by_category_bar_plot_lc +
    geom_bar(stat = "identity", position = position_dodge())
  treated_by_category_bar_plot_lc  = treated_by_category_bar_plot_lc +
    labs(x = "\n Tweet Category",
         y = "Average Like Count \n", 
         fill = l_title)
  filename = paste0(plot_directory, "lc_category_bp.pdf")
  ggsave(filename, treated_by_category_bar_plot_lc, width = w, height = h)
  
  treated_by_category_bar_plot_qc <-
    ggplot(r[[1]], aes(tweet_category,
                       avg_quoteCount,
                       fill = treatment))
  treated_by_category_bar_plot_qc = treated_by_category_bar_plot_qc +
    geom_bar(stat = "identity", position = position_dodge())
  treated_by_category_bar_plot_qc  = treated_by_category_bar_plot_qc +
    labs(x = "\n Tweet Category",
         y = "Average Quote Count \n", 
         fill = l_title)
  filename = paste0(plot_directory, "qc_category_bp.pdf")
  ggsave(filename, treated_by_category_bar_plot_qc, width = w, height = h)
  
  treated_by_category_bar_plot_num_posts <-
    ggplot(r[[1]], aes(tweet_category,
                       num_posts,
                       fill = treatment))
  treated_by_category_bar_plot_num_posts = treated_by_category_bar_plot_num_posts +
    geom_bar(stat = "identity", position = position_dodge())
  treated_by_category_bar_plot_num_posts  = treated_by_category_bar_plot_num_posts +
    labs(x = "\n Tweet Category",
         y = "Total Number of Posts \n", 
         fill = l_title)
  filename = paste0(plot_directory, "num_posts_category_bp.pdf")
  ggsave(filename, treated_by_category_bar_plot_num_posts, width = w, height = h)
  
  bar_plots = list(
    treated_by_category_bar_plot_rc,
    treated_by_category_bar_plot_lc,
    treated_by_category_bar_plot_qc,
    treated_by_category_bar_plot_num_posts
  )
  return(bar_plots)
}

create_plots_for_contains_hashtag <- function(r, plot_directory,w,h,l_title) {
  treated_by_contains_hashtag <-
    ggplot(r[[2]],
           aes(treatment, avg_replyCount))
  treated_by_contains_hashtag + geom_line(aes(colour = factor(contains_hashtag)))
  
  r[[2]]$treatment = as.factor(r[[2]]$treatment)
  r[[2]]$contains_hashtag = as.factor(r[[2]]$contains_hashtag)
  
  treated_contains_hash_bar_plot_rc <-
    ggplot(r[[2]], aes(contains_hashtag,
                       avg_replyCount,
                       fill = treatment))
  treated_contains_hash_bar_plot_rc = treated_contains_hash_bar_plot_rc +
    geom_bar(stat = "identity", position = position_dodge())
  treated_contains_hash_bar_plot_rc  = treated_contains_hash_bar_plot_rc +
    labs(x = "\n Contains Hashtag",
         y = "Average Reply Count \n", 
         fill = l_title)
  filename = paste0(plot_directory, "rc_contains_hash_bp.pdf")
  ggsave(filename, treated_contains_hash_bar_plot_rc, width = w, height = h)
  
  
  
  treated_contains_hash_bar_plot_lc <-
    ggplot(r[[2]], aes(contains_hashtag,
                       avg_likeCount, fill =
                         treatment))
  treated_contains_hash_bar_plot_lc = treated_contains_hash_bar_plot_lc +
    geom_bar(stat = "identity",
             position = position_dodge())
  treated_contains_hash_bar_plot_lc  = treated_contains_hash_bar_plot_lc +
    labs(x = "\n Contains Hashtag",
         y = "Average Like Count \n", 
         fill = l_title)
  filename = paste0(plot_directory, "lc_contains_hash_bp.pdf")
  ggsave(filename, treated_contains_hash_bar_plot_lc, width = w, height = h)
  
  treated_contains_hash_bar_plot_qc <-
    ggplot(r[[2]], aes(contains_hashtag,
                       avg_quoteCount,
                       fill = treatment))
  treated_contains_hash_bar_plot_qc = treated_contains_hash_bar_plot_qc +
    geom_bar(stat = "identity",
             position = position_dodge())
  treated_contains_hash_bar_plot_qc  = treated_contains_hash_bar_plot_qc +
    labs(x = "\n Contains Hashtag",
         y = "Average Quote Count \n", 
         fill = l_title)
  filename = paste0(plot_directory, "qc_contains_hash_bp.pdf")
  ggsave(filename, treated_contains_hash_bar_plot_qc, width = w, height = h)
  
  
  treated_by_contains_hashtag_plot_num_posts <-
    ggplot(r[[2]], aes(contains_hashtag,
                       num_posts,
                       fill = treatment))
  treated_by_contains_hashtag_plot_num_posts = 
    treated_by_contains_hashtag_plot_num_posts +
    geom_bar(stat = "identity", position = position_dodge())
  treated_by_contains_hashtag_plot_num_posts  = treated_by_contains_hashtag_plot_num_posts +
    labs(x = "\n Contains Hashtag",
         y = "Total Number of Posts \n", 
         fill = l_title)
  filename = paste0(plot_directory, "num_posts_contains_hash_bp.pdf")
  ggsave(filename, treated_by_contains_hashtag_plot_num_posts, width = w, height = h)
  
  barplot_list = list(
    treated_contains_hash_bar_plot_rc,
    treated_contains_hash_bar_plot_lc,
    treated_contains_hash_bar_plot_qc,
    treated_by_contains_hashtag_plot_num_posts
  )
  return(barplot_list)
}

create_time_trend_plots_by_category <- function(r){
  dates_vline <- as.Date(c("2020-05-25")) 
  dates_vline <- which(r[[4]]$Year_month_day %in% dates_vline)
  
  r[[4]]$Year_month_day = as.Date(r[[4]]$Year_month_day)
  q = ggplot(r[[4]], aes(x = Year_month_day, y = avg_replyCount))
  q = q + geom_line(aes(colour = factor(tweet_category)))
  q = q +                                                                 # Draw vlines to plot
    geom_vline(xintercept = 
                 as.numeric(r[[4]]$Year_month_day[dates_vline]),
               col = "red", lwd = 1)
  
  
  p = ggplot(r[[4]], aes(x = Year_month_day, y = avg_likeCount))
  p = p + geom_line(aes(colour = factor(tweet_category)))
  p = p +                                                                 # Draw vlines to plot
    geom_vline(xintercept = 
                 as.numeric(r[[4]]$Year_month_day[dates_vline]),
               col = "red", lwd = 1)
  p = p +                                                                 # Draw vlines to plot
    geom_vline(xintercept = 
                 as.numeric(r[[4]]$Year_month_day[dates_vline]),
               col = "red", lwd = 1)
  
  
  
  np = ggplot(r[[4]], aes(x = Year_month_day, y = log(num_posts)))
  np = np + geom_line(aes(colour = factor(tweet_category)))
  np = np + labs(x = "\n Time", y = "log(Number of Posts) \n",
                 fill = "Tweet Category")
  np = np +                                                                 # Draw vlines to plot
    geom_vline(xintercept = 
                 as.numeric(r[[4]]$Year_month_day[dates_vline]),
               col = "red", lwd = 1)
  return(list(p,q,np))
}

create_time_trend_plots_contains_hash <- function(r,index,w,h,
                                                  plot_directory){
  dates_vline <- as.Date(c("2020-05-25")) 
  r[[index]]$Year_month_day = as.Date(r[[index]]$Year_month_day)
  dates_vline <- which(r[[index]]$Year_month_day %in% dates_vline)
  
  r[[index]]$Year_month_day = as.Date(r[[index]]$Year_month_day)
  r[[index]]$new_index = paste(r[[index]]$contains_hashtag,
                               r[[index]]$BLM)
  r[[index]]$new_index = gsub("\\s+", ",", gsub("^\\s+|\\s+$",
                                                "",r[[index]]$new_index))
  
  rc = ggplot(r[[index]], aes(x = Year_month_day, y = avg_replyCount))
  rc = rc + geom_line(aes(colour = factor(new_index)))
  rc = rc +                                                               
    geom_vline(xintercept = 
                 as.numeric(r[[index]]$Year_month_day[dates_vline]),
               col = "red", lwd = 1) + 
    labs(x = "\n Date",
        y = "Average Reply Count \n", color = "Has Hash, BLM")
  filename = paste0(plot_directory, "rc_trend_blm_hash.pdf")
  ggsave(filename, rc, width = w, height = h)
  
  
  lc = ggplot(r[[index]], aes(x = Year_month_day, y = avg_likeCount))
  lc = lc + geom_line(aes(colour = factor(new_index)))
  lc = lc +                                                                 
    geom_vline(xintercept = 
                 as.numeric(r[[index]]$Year_month_day[dates_vline]),
               col = "red", lwd = 1) + 
    labs(x = "\n Date",
         y = "Average Like Count \n", color = "Has Hash, BLM")
  filename = paste0(plot_directory, "lc_trend_blm_hash.pdf")
  ggsave(filename,lc, width = w, height = h)
  
  
  
  qc = ggplot(r[[index]], aes(x = Year_month_day, y = avg_quoteCount))
  qc = qc + geom_line(aes(colour = factor(new_index)))
  qc = qc +                                                                 
    geom_vline(xintercept = 
                 as.numeric(r[[index]]$Year_month_day[dates_vline]),
               col = "red", lwd = 1) + 
    labs(x = "\n Date",
         y = "Average Quote Count \n", color = "Has Hash, BLM")
  filename = paste0(plot_directory, "qc_trend_blm_hash.pdf")
  ggsave(filename, qc, width = w, height = h)
  
  np = ggplot(r[[index]], aes(x = Year_month_day, y = log(num_posts)))
  np = np + geom_line(aes(colour = factor(new_index)))
  np = np + labs(x = "\n Date", y = "log(Number of Posts) \n",
                 color = "Has Hash, BLM")
  np = np +                                                             
    geom_vline(xintercept = 
                 as.numeric(r[[index]]$Year_month_day[dates_vline]),
               col = "red", lwd = 1)
  filename = paste0(plot_directory, "np_trend_blm_hash.pdf")
  ggsave(filename, np, width = w, height = h)
  
  return(list(lc,qc,rc,np))
}

w = 9
h = 5
l_title = "Before/After \nGeorge Floyd"
barplots_by_category = create_plots_for_tweet_category(r,
                                                       plot_directory,
                                                       w,h,l_title)
barplots_contains_hashtag = create_plots_for_contains_hashtag(r,
                                                              plot_directory,
                                                              w,h,l_title)


time_trend_plots_by_c = create_time_trend_plots_by_category(r,index,
                                                            w,h,
                                                            plot_directory)

index = 6
time_trend_plots_contains_hash = create_time_trend_plots_contains_hash(r,index,
                                                                       w,h,
                                                                       plot_directory)

time_trend_plots_contains_hash[[2]]

kable(r[[6]][,c(1,2,3,4,5,6)], "latex", digits = 3, caption = "Summary Statistics")

kable(r[[5]][,c(1,2,3,4,5,6)], "latex", digits = 3, caption = "Summary Statistics")


