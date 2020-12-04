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

git commit -m 'add commons'
git push 

dvc remote add -d storage s3://itx-bjd-app-iq/development/development/schuvaki/dvc
git commit .dvc/config -m "Configure remote storage"

dvc push
dvc pull

dvc list https://github.com/sergeychuvakin/DVC-test.git