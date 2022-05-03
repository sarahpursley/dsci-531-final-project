#!/usr/bin/env python
# coding: utf-8
import os
import pandas as pd

# edit tweet ount for desired max results -- cut down time and json output file
def pull_tweets(hashtags, dates, tweet_count = 100000):
    idx = 0
    for i in range(len(dates)):
        date_name = str(dates[i][0]) + "-" + dates[i][1]
        print(date_name)
        
        file = "data/text-query-tweets-" + date_name
    
        for hashtag in hashtags:
            file_name = file + "-" + hashtag + ".json"
            print(hashtag)

            # OS library to call CLI commands 
            scrape = 'snscrape --jsonl --max-results {} --since {} twitter-hashtag "{} until:{}"> {}'.format(
            tweet_count, date_ranges[i][0], hashtag, date_ranges[i][1], file_name)

            os.system(scrape)
            
if __name__ == '__main__':
    # DAPL hashtags
    hashtags = ["#NODAPL","#DakotaAccess", "#DakotaPipeline", 
                "#DakotaAccessPipeline","#PipelinesareLifelines", "#ReZpectOurWater", 
                "#DAPLmatters", "#NoBakken", "#NoDAP", "#Bakken", "#KeepItInTheGround"]

    # date ranges for tweets
    date_ranges = [["2016-01-25","2016-07-27"],
                   ["2016-07-27","2016-09-03"],
                   ["2016-09-03","2016-09-09"],
                   ["2016-09-09", "2016-09-26"],
                   ["2016-09-26", "2016-10-09"],
                   ["2016-10-09", "2016-10-11"],
                   ["2016-10-11", "2016-10-25"],
                   ["2016-10-25", "2016-10-27"],
                   ["2016-10-27", "2016-11-01"]]

    pull_tweets(hashtags, dates, tweet_count = 100000)
