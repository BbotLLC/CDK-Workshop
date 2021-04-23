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
    sudo chmod 700 setup.sh
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

1. The first thing we will do is create an example Lambda to deploy. Open a terminal inside the CDK-Workshop/cdk-demo folder and type:
    ```bash
    cd cdk-demo
    sam init
    1 - AWS Quick Start Templates
    1 - Zip
    2 - Python 3.8
    [Enter] to select default name (sam-app)
    1 - Hello World Example
    ```

2. Open the sam-app/hello_world/app.py file and take a look at the code. It is a standard static message returned in the form of a JSON. Accompanying the JSON is a requirements file which should include any external libraries that should be downloaded during the build command

3. Let's test our Lambda locally first navigate to our sam-app folder and then use the build command before we invoke our Lambda with sudo
    ```bash
    cd sam-app
    sam build
    sudo sam local invoke
    ```

4. Great! Now that we have a working Lambda and we are able to quickly test it locally, let's deploy it with CDK. Although CLI can deploy Lambda, it is limited in scope as to other AWS services you can define that interact with the Lambda.

5. Open app.py in the root of our project directory and make sure to change the stack name "CdkDemoStack" to something unique

    ```python
    app = core.App()
    CdkDemoStack(app, "SahmsDemoStack",
    # If you don't specify 'env', this stack will be environment-agnostic.
    ```
6. Finally open the cdk_demo_stack.py file inside the cdk_demo folder and copy and paste the following making sure to set nameOfLambda to your desired name (this doesn't need to be unique by rule as a final name will be generated with a unique id suffix)

    ```python
    from aws_cdk import core as cdk
    from aws_cdk import aws_lambda as _lambda

    nameOfLambda="SahmHelperFunction"
    nameOfFunction="app.lambda_handler" # This is derived from the name of the file inside the Lambda (hello.py) and the function we are calling (handler)
    nameOfLocation="sam-app/.aws-sam/build/HelloWorldFunction"

    class CdkDemoStack(cdk.Stack):

        def __init__(self, scope: cdk.Construct, construct_id: str, **kwargs) -> None:
            super().__init__(scope, construct_id, **kwargs)

            # The code that defines your stack goes here
            fn = _lambda.Function(self,
                                nameOfLambda,
                                handler=nameOfFunction,
                                runtime=_lambda.Runtime.PYTHON_3_8,
                                code=_lambda.Code.from_asset(nameOfLocation))
    ```

7. You can now preview the changes about to be made by using the diff command

    ```bash
    cd ..
    source ./.venv/bin/activate
    cdk diff --profile cdkdemo
    ```

8. You can deploy your stack

    ```bash
    cdk deploy --profile cdkdemo
    ```

9. And you can remove your stack

    ```bash
    cdk destroy --profile cdkdemo
    ```

10. You are encouraged to look at the other parameters and play with other modules after this workshop. If you want to learn more please visit [AWS CDK Python Documentation](https://docs.aws.amazon.com/cdk/api/latest/python/aws_cdk.aws_lambda/README.html) and [AWS SAM Generate Event](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-cli-command-reference-sam-local-generate-event.html)