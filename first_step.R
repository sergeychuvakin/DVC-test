setwd('/mnt/DVC-test')
source('common.R')

df <- s3_read_csv('development/schuvaki/dvc/elections.csv')

df["year"] <- df["year"] + 1

s3_write_csv(df, 'development/schuvaki/dvc/elections_2.csv')
