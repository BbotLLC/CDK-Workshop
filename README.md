# CDK Workshop

This workshop is a quick introduction into the Amazon Web Services Cloud Development Kit or AWS CDK for short.

CDK is a tool to assist in creating Infrastructure as Code. Benefits include clarity and control over your infrastructure, lower rates of human error due to being able to control changes through
well defined pipelines, and being able to roll back changes/see a history of the infrastructure by keeping it in a repository the same as you would application code.

## Pre-requisites

This guide is written for Ubuntu and Ubuntu variants using apt-get and snap as their package managers.

1. Ensure you have git installed:

    ```bash
    sudo apt-get install git
    ```

2. Clone this repo:

    ```bash
    git clone https://github.com/BbotLLC/CDK-Workshop
    ```

3. Ensure you have rights to execute

    ```bash
    cd CDK-Workshop/
    chmod 700 setup.sh
    ```

4. Run the setup script to install all required libraries and tools. When prompted for credentials, use the access and secret keys shared with you over Lastpass. If you don't have credentials contact sahm.samarghandi@bbot.menu to request access. Don't worry about overwriting your current credentials, the script saves them under the cdkdemo profile.

    ```bash
    ./setup.sh
    ```
    You will also be prompted to install Pycharm if you do not have an IDE installed. This is optional and you are free to use any text editor or IDE you wish.

## CDK Commands you didn't type

The setup script will run the cdk init command for you in order to setup the workshop and install pre-requisite Python libraries in the virtual environment.
If you later want to initialize a new project use:
```
cdk init app -l=python
```

On a new environment you'll also need to do something called "bootstrapping" in order to prep a new AWS account for CDK. This has been done already for the target account but if you need to bootstrap a new account (once for each region), you'll use:
```
cdk bootstrap
```

Lastly, this script installed the python libraries for you. You will need the core which is found in the requirements.txt and by manually including any "modules" of the CDK you need. In our case we need Lambda as well. You'll want to use virtual environments to keep your host OS clean. 
```
source .venv/bin/activate

pip3 install -r requirements.txt
pip3 install aws_cdk.aws_lambda
```

## Commands for this workshop

Here is the meat and potatos of this workshop. You will want to edit some of the code in order to generate a new Lambda in AWS.

Remember that we saved our credentials under --profile cdkdemo so ensure you use that flag for this demo and exclude it in your future workflow. 

1. The first thing we will do is create an example Lambda to deploy. Open a terminal inside the CDK-Workshop folder and type:
    ```
    mkdir lambdaCode
    touch lambdaCode/hello.py
    ```

2. Open the hello.py file we just created with the touch command and copy and paste the following handler code:
    ```python
    def handler(event, context):
        return "Hello, BBot!"
    ```
3. Open app.py in the root of our project directory and make sure to change then stack name "CdkDemoStack" to something unique

    ```python
    app = core.App()
    CdkDemoStack(app, "SahmsDemoStack",
    # If you don't specify 'env', this stack will be environment-agnostic.
    ```