setwd('/mnt/DVC-test')
source('common.R')

df <- s3_read_csv('development/schuvaki/dvc/elections_2.csv')

df['new_col'] <- df['gdp.growth'] + 20

s3_write_csv(df, 'development/schuvaki/dvc/elections_3.csv')
