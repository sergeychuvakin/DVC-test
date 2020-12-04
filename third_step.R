setwd('/mnt/DVC-test')

source('common.R')

df <- s3_read_csv('development/schuvaki/dvc/elections_3.csv')

df['new_col_2'] <- df['new_col'] + df['year']

s3_write_csv(df, 'development/schuvaki/dvc/elections_4.csv')