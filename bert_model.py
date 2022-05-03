import numpy as np
import pandas as pd
import json
import random

# import Pytorch and transformers library
import torch
from transformers import AutoModel, AutoTokenizer
import transformers as ppb
import emoji

def run_bert(df):
    # get list of tokenized input
    tokenized = df["content"].apply((lambda x: tokenizer.encode(str(x))[:128]))

    # pad tokenized array to 128 characters
    padded = np.array([i + [0]*(128-len(i)) for i in tokenized.values])
    attention_mask = np.where(padded != 0, 1, 0)

    # model inputs
    input_ids = torch.tensor(padded)
    attention_mask = torch.tensor(attention_mask)

    # run model 
    with torch.no_grad():
        last_hidden_states = model(input_ids, attention_mask=attention_mask)

    # get features
    features = last_hidden_states[0][:,0,:].numpy()

    feature_dict = {}
    m = 0

    # create feature dict to store tokenized inputs and word vector features for each tweet
    for i in tokenized:
        feature_dict.setdefault(m, None)
        feature_dict[m] = [i, list(features[m])]
        m += 1

    # save results
    result_df = pd.DataFrame.from_dict(feature_dict, orient='index')

    return result_df

if __name__ == '__main__':
    # initialize the tokenizer from pretrained BERT model 
    # https://github.com/VinAIResearch/BERTweet
    tokenizer = AutoTokenizer.from_pretrained("vinai/bertweet-base", normalization=True)
    model = AutoModel.from_pretrained("vinai/bertweet-base" )

    dapl_input_before = "data/joined_data_before.csv"
    dapl_input_after = "data/joined_data_after.csv"

    before_output_file
    after_output_file

    # read in tweet data from "Before" period, no extra pre-processing
    df_before = pd.read_csv(dapl_input_before)

    # sample the after data to run model on smaller sample
    # take random sample so the dates and tweets are randomly distributed
    df_after = pd.read_csv(dapl_input_after)
    df_after = df_after.dropna(subset=['content'])
    df_sampled = df_after.sample(frac=0.75, replace=True, random_state=1).reset_index()

    # save intermedidate to csv
    df_sampled.to_csv('data/sampled_after_data.csv', index=False)

    # run bert models
    bert_model_before = run_bert(df_before)
    bert_model_after = run_bert(df_sampled)

    # write out bert results
    bert_model_before.to_csv(output_file)
    bert_model_after.to_csv(output_file)

