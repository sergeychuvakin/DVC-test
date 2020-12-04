### install 
sudo wget \
       https://dvc.org/deb/dvc.list \
       -O /etc/apt/sources.list.d/dvc.list
       
sudo apt update 

sudo apt install dvc
dvc --version

### repos 

git clone https://github.com/sergeychuvakin/DVC-test.git

cd DVC-test

touch first_step.R
touch second_step.R
touch third_step.R
touch common.R
touch tutorial.sh

git add .
git commit -m 'second commit'

git config --global user.name 'Sergey Chuvakin'
git config --global user.email 'sergeychuvakin1@mail.ru'

git push

dvc init

git commit -a -m 'dvc introduction'

git push

git rm elections.csv
git rm elections_2.csv
git rm elections_3.csv
git rm elections_4.csv

git add .
git commit -m 'add sh file'
git push 






dvc push
dvc pull


aws s3 cp s3://itx-bjd-app-iq/development/development/schuvaki/dvc ./data --sse --recursive
dvc add data/
git add .gitignore data.dvc

git add .

git commit -m 'add raw and shell script'
git push

git status
dvc status

dvc remote add -fd --external storage s3://itx-bjd-app-iq/development/development/schuvaki/dvc
git commit .dvc/config -m "Configure remote storage"


dvc push #2> er.txt > out.txt

dvc remote list

dvc checkout
# 
# dvc config cache.s3 storage

# 
# dvc remote modify storage credentialpath ~/.aws/credentials
# dvc remote modify storage profile profile-name


aws s3 ls s3://itx-bjd-app-iq/development/development/schuvaki/dvc

cat .dvc/config

