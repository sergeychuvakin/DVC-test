setwd('/mnt/DVC-test')

df <- read.csv('elections_2.csv')

df['new_col'] <- df['gdp.growth'] + 20

write.csv(df, 'elections_3.csv')
