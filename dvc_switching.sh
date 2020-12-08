#!/bin/bash

## install 
sudo wget \
       https://dvc.org/deb/dvc.list \
       -O /etc/apt/sources.list.d/dvc.list

sudo apt update 
sudo apt install dvc

## add remote dvc repo, where data is phisically stored
dvc remote add -df repo s3://
dvc remote modify repo sse AES256

## copy data for project
data_s3=""
aws s3 cp "$DATA_HOME/$data_s3" "/repos/repo/data/$data_s3"

## add to dvc and git inforamton about input data
dvc add "/repos/repo/data/$data_s3"
git add "data/$data_s3.dvc" data/.gitignore

## push input to dvs storage 
dvc push 

### then update yaml and scripts itself to make them work with local files

## check if your logic in yaml works. Besides it produces output files that also shuold be in dvc 
dvc repro -f cache

## add to git all chacnges files related to dvc, you can do via git add .
git add .

git config --global user.name 'Sergey Chuvakin'
git config --global user.email ''

## commit with ticket
git commit -m ''

## push all
dvc push
git push
