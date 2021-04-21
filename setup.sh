#!/bin/bash
sudo apt-get update
sudo apt-get install docker python3 python3-pip nodejs npm curl python3-venv git -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
unzip awscliv2.zip
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
sudo ./sam-installation/install
sudo ./aws/install
sudo npm install -g aws-cdk
aws configure --profile cdkdemo

mkdir cdk-demo
cd cdk-demo
cdk init app -l=python
python3 -m venv .venv

checkPyCom=$(which pycharm-community)
checkPyPro=$(which pycharm-professional)

if [[ ${#checkPyCom} = 0 || ${#checkPyCom} = 0 ]];
then
    echo "Do you want to install Pycharm Community Edition?"
    read answer
    answer=${answer,,}
    if [ ${answer::1} == 'y' ]
    then
        snap install pycharm-community --classic
    fi
fi

source .venv/bin/activate
pip3 install -r requirements.txt
pip3 install aws_cdk.aws_lambda

cd ..

pycharm-professional cdk-demo/ &>/dev/null & disown 
pycharm-community cdk-demo/ &>/dev/null & disown


rm -r -f $PWD/aws/
rm $PWD/awscliv2.zip
rm $PWD/aws-sam-cli-linux-x86_64.zip