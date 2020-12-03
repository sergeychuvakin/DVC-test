setwd('/mnt/DVC-test')

df <- read.csv('elections_3.csv')

df['new_col_2'] <- df['new_col'] + df['year']

write.csv(df, 'elections_4.csv')