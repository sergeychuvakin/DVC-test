setwd('/mnt/DVC-test')

df <- read.csv('elections.csv')

df["year"] <- df["year"] + 1

write.csv(df, 'elections_2.csv')
