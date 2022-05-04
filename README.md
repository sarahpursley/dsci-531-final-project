# DSCI 531 Final Project
## Shadow Banning on Social Media 
<div id="top"></div>

<!-- ABOUT THE PROJECT -->
## About The Project

Abstract:
In this project, we are interested in two questions: do companies shadow-ban, and if they do, are marginalized communities adversely targeted? Lay-theory and journalistic evidence points to both of these outcomes being true, but little systematic research has attempted to analyze whether these outcomes are fact or fiction. We attempt to be one of the first papers to try and rigorously identify whether companies are shadow-banning content on online platforms. Using scrapped Twitter data, we propose an identification strategy to see whether certain hashtags are being targeted by a Twitter moderation system. Initial results suggests that new hashtags may be negatively moderated, i.e., shadow-banned. 

This repository contains the code we used to conduct our analysis. We have included code for data collection and pre-processing as well as our final regression analysis.

Data Source:
* Twitter API using snscrape python package

Data Analysis
* BERTweet, PCA, Regression 

<p align="right">(<a href="#top">back to top</a>)</p>

### Programming Languages

We completed the analysis for this project using both R and Python programming languages.

* [R](https://www.r-project.org/)
* [Python](https://www.python.org/)


<p align="right">(<a href="#top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Instructions
To generate our project results, we have included the following instructions.

### Downloading & Running Code
_To run the main analysis, we have included the final input data and R scripts._

Input data:

The following files are found in the data folder:
  *Final Control Input Data: [final_control_df.csv](final_control_df.csv)
  *Final Treated Input Data: [plot-twitter-data.R](final_treated_df.csv)

1. Clone the repository onto local machine 
   ```sh
   git clone https://github.com/your_username/Project-Name.git
   ```
2. Download and install RStudio for running R code: https://www.rstudio.com/products/rstudio/download/
4. Navigate to cloned repository on your local machine
5. Open the following files:

  [regression.R](regression/regression.R)
  [plot-twitter-data.R](regression/plot-twitter-data.R)

6. Run script in RStudio

#### Additional Code
We have also included the code we used for data collection and pre-processing. However, we have included the final input data under the data folder as this code takes a long time to run. It is not necessary to run this code but we have included them for reference.

Data Collection
   ```sh
   python pre-processing/get_tweets.py
   ```
   
BERTweet
   ```sh
   python pre-processing/bert_model.py
   ```
   
BERTweet Matching & PCA
1. Run the following to start Jupyter notebook
   ```sh
   jupyter notebook
   ```
2. Open "matching-data.ipynb"
3. Run code in Jupyter notebook

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

Poet Larson  - Poet.Larson@usc.edu
Sarah Pursley - spursley@usc.edu

Project Link: [https://github.com/your_username/repo_name](https://github.com/your_username/repo_name)

<p align="right">(<a href="#top">back to top</a>)</p>
