library(lfe)
library(zoo)
library(stargazer)

###################BLM Analysis######################
basic_reg_lc = felm(likeCount ~ contains_hashtag + 
                      BLM + treatment:contains_hashtag +  BLM:contains_hashtag +
                      BLM:treatment + BLM:treatment:contains_hashtag| 
                      Year_month_day + who_posted | 0 | who_posted,data = non_duplicates)
summary(basic_reg_lc)

basic_reg_no_consumer_fc_lc = felm(likeCount ~ contains_hashtag + 
                                     BLM + treatment:contains_hashtag +  BLM:contains_hashtag +
                                     BLM:treatment + BLM:treatment:contains_hashtag| 
                                     Year_month_day  | 0 | who_posted,data = non_duplicates)
summary(basic_reg_no_consumer_fc_lc)

basic_reg_rc = felm(replyCount ~ contains_hashtag + 
                      BLM + treatment:contains_hashtag +  BLM:contains_hashtag +
                      BLM:treatment + BLM:treatment:contains_hashtag| 
                      Year_month_day + who_posted | 0 | who_posted,data = non_duplicates)
summary(basic_reg_rc)

basic_reg_qc = felm(quoteCount ~ contains_hashtag + 
                      BLM + treatment:contains_hashtag +  BLM:contains_hashtag +
                      BLM:treatment + BLM:treatment:contains_hashtag| 
                      Year_month_day + who_posted | 0 | who_posted,data = non_duplicates)
summary(basic_reg_qc)

stargazer(basic_reg_no_consumer_fc_lc,basic_reg_lc,basic_reg_rc,basic_reg_qc)



tweet_category_reg_lc = felm(likeCount ~ tweet_category + 
                               tweet_category:treatment| 
                               Year_month_day + who_posted | 0 | who_posted , data = non_duplicates)
summary(tweet_category_reg_lc)



###################DAPL Analysis######################
base_directory = getwd()
tweets_dir = file.path(base_directory,"tweet_data","tweets","DAPL")

control = read.csv(file.path(tweets_dir,"final_control_df.csv"))
treated = read.csv(file.path(tweets_dir,"final_treated_df.csv"))

colnames(treated)
control_match_vector = treated[,43]
treated_reg_cols = c(8,13,14,15,16,35,39,40,44)
control_reg_cols = c(8,13,14,15,16,35,39,40,43)
complete_reg_dataset = rbind(control[,control_reg_cols], treated[,treated_reg_cols])

complete_reg_dataset$yearmonday = format(as.Date(complete_reg_dataset$date),
                                         "%Y-%m-%d")
complete_reg_dataset$yearmonday = as.Date(complete_reg_dataset$yearmonday)
complete_reg_dataset$user_id = as.factor(complete_reg_dataset$user_id)

#########Likes
likes_baseline_reg = felm(likeCount ~ has_new_hash | 0 | 0 | 0,
                    data = complete_reg_dataset)
summary(likes_baseline_reg)

likes_time_fe_reg = felm(likeCount ~ has_new_hash | yearmonday | 0 | 0,
                   data = complete_reg_dataset)
summary(likes_time_fe_reg)

likes_user_fe_reg = felm(likeCount ~ has_new_hash | user_id | 0 | 0,
                   data = complete_reg_dataset)
summary(likes_user_fe_reg)

likes_full_reg = felm(likeCount ~ has_new_hash | yearmonday + user_id | 0 | 0,
                    data = complete_reg_dataset)
summary(likes_full_reg)

########replyCount
colnames(complete_reg_dataset)
reply_baseline_reg = felm(replyCount ~ has_new_hash | 0 | 0 | 0,
                          data = complete_reg_dataset)
summary(reply_baseline_reg)

reply_time_fe_reg = felm(replyCount ~ has_new_hash | yearmonday | 0 | 0,
                         data = complete_reg_dataset)
summary(reply_time_fe_reg)

reply_full_reg = felm(replyCount ~ has_new_hash | yearmonday + user_id | 0 | 0,
                      data = complete_reg_dataset)
summary(reply_full_reg)

#######quoteCount
quote_baseline_reg = felm(quoteCount ~ has_new_hash | 0 | 0 | 0,
                          data = complete_reg_dataset)
summary(quote_baseline_reg)

quote_time_fe_reg = felm(quoteCount ~ has_new_hash | yearmonday | 0 | 0,
                         data = complete_reg_dataset)
summary(quote_time_fe_reg)

quote_full_reg = felm(quoteCount ~ has_new_hash | yearmonday + user_id | 0 | 0,
                      data = complete_reg_dataset)
summary(quote_full_reg)

#######retweetCount
retweet_baseline_reg = felm(retweetCount ~ has_new_hash | 0 | 0 | 0,
                          data = complete_reg_dataset)
summary(retweet_baseline_reg)

retweet_time_fe_reg = felm(retweetCount ~ has_new_hash | yearmonday | 0 | 0,
                         data = complete_reg_dataset)
summary(retweet_time_fe_reg)

retweet_full_reg = felm(retweetCount ~ has_new_hash | yearmonday + user_id | 0 | 0,
                      data = complete_reg_dataset)
summary(retweet_full_reg)


#baseline regressions
stargazer(likes_baseline_reg,reply_baseline_reg,
          quote_baseline_reg,retweet_baseline_reg)

#Time FE regressions
stargazer(likes_time_fe_reg,reply_time_fe_reg,
          quote_time_fe_reg,retweet_time_fe_reg)

#Full regressions
stargazer(likes_full_reg,reply_full_reg,quote_full_reg,retweet_full_reg)

