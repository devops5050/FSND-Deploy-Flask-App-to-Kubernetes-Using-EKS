# Deploying a Flask API

This is the project starter repo for the fourth course in the [Udacity Full Stack Nanodegree](https://www.udacity.com/course/full-stack-web-developer-nanodegree--nd004): Server Deployment, Containerization, and Testing.

In this project you will containerize and deploy a Flask API to a Kubernetes cluster using Docker, AWS EKS, CodePipeline, and CodeBuild.

The Flask app that will be used for this project consists of a simple API with three endpoints:

- `GET '/'`: This is a simple health check, which returns the response 'Healthy'. 
- `POST '/auth'`: This takes a email and password as json arguments and returns a JWT based on a custom secret.
- `GET '/contents'`: This requires a valid JWT, and returns the un-encrpyted contents of that token. 

The app relies on a secret set as the environment variable `JWT_SECRET` to produce a JWT. The built-in Flask server is adequate for local development, but not production, so you will be using the production-ready [Gunicorn](https://gunicorn.org/) server when deploying the app.

## Initial setup
1. Fork this project to your Github account.
2. Locally clone your forked version to begin working on the project.

## Dependencies

- Docker Engine
    - Installation instructions for all OSes can be found [here](https://docs.docker.com/install/).
    - For Mac users, if you have no previous Docker Toolbox installation, you can install Docker Desktop for Mac. If you already have a Docker Toolbox installation, please read [this](https://docs.docker.com/docker-for-mac/docker-toolbox/) before installing.
 - AWS Account
     - You can create an AWS account by signing up [here](https://aws.amazon.com/#).
     
## Project Steps

Completing the project involves several steps:

1. Write a Dockerfile for a simple Flask API
2. Build and test the container locally
3. Create an EKS cluster
4. Store a secret using AWS Parameter Store
5. Create a CodePipeline pipeline triggered by GitHub checkins
6. Create a CodeBuild stage which will build, test, and deploy your code

For more detail about each of these steps, see the project lesson [here](https://classroom.udacity.com/nanodegrees/nd004/parts/1d842ebf-5b10-4749-9e5e-ef28fe98f173/modules/ac13842f-c841-4c1a-b284-b47899f4613d/lessons/becb2dac-c108-4143-8f6c-11b30413e28d/concepts/092cdb35-28f7-4145-b6e6-6278b8dd7527).


History of terminal:

docker pull postgres:latest

docker run --name psql -e POSTGRES_PASSWORD=password! -p 5432:5432 -d postgres:latest

psql -h 0.0.0.0 -p 5432 -U postgres

docker ps

docker stop d541cda05480

docker ps

aws configure list

brew tap weaveworks/tap

brew install weaveworks/tap/eksctl

curl --silent --location "‌https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname‌ -s)_amd64.tar.gz" | tar xz -C /tmp

echo $uname

uname

curl --silent --location https://github.com/weaveworks/eksctl/releases/download/0.37.0/eksctl_Darwin_amd64.tar.gz | tar xz -C /tmp

ls -la /tmp

sudo mv /tmp/eksctl /usr/local/bin

wihch eksctl

eksctl -v

kubectl version

echo "$(<kubectl.sha256)  kubectl" | shasum -a 256 --check

kubectl version --client

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"

curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl.sha256"

echo "$(<kubectl.sha256)  kubectl" | shasum -a 256 --check

chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl && sudo chown root: /usr/local/bin/kubectl

kubectl version --client

kubectl version

python3 --version

git clone https://github.com/devops5050/FSND-Deploy-Flask-App-to-Kubernetes-Using-EKS.git

cd FSND-Deploy-Flask-App-to-Kubernetes-Using-EKS/

python3 -m virtualenv eks-env

source eks-env/bin/activate

pip3 install -r requirements.txt

export JWT_SECRET='myjwtsecret'
export LOG_LEVEL=DEBUG

echo $JWT_SECRET 
echo $LOG_LEVEL 

python3 main.py 

export TOKEN=`curl -d '{"email":"hiway@myway.com","password":"welcome"}' -H "Content-Type: application/json" -X POST localhost:80/auth  | jq -r '.token'`

curl --request GET 'http://127.0.0.1:80/contents' -H "Authorization: Bearer ${TOKEN}" | jq .

brew tap weaveworks/tap

eksctl create cluster --name simple-jwt-api
kubectl get nodes

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo $ACCOUNT_ID

TRUST="{ \"Version\": \"2012-10-17\", \"Statement\": [ { \"Effect\": \"Allow\",  \"Principal\": { \"AWS\": \"arn:aws:iam::${ACCOUNT_ID}:root\" }, \"Action\":  \"sts:AssumeRole\" } ] }"

echo $TRUST

aws iam create-role --role-name UdacityFlaskDeployCBKubectlRole --assume-role-policy-document "$TRUST" --output text --query 'Role.Arn'

aws iam create-role --role-name UdacityFlaskDeployCBKubectlRole --assume-role-policy-document "$TRUST" --output text --query 'Role.Arn'

echo '{ "Version": "2012-10-17", "Statement": [ { "Effect": "Allow", "Action": [ "eks:Describe*", "ssm:GetParameters" ], "Resource": "*" } ] }' > ./iam-role-policy

aws iam put-role-policy --role-name UdacityFlaskDeployCBKubectlRole --policy-name eks-describe --policy-document file://./iam-role-policy

kubectl get -n kube-system configmap/aws-auth -o yaml > ./aws-auth-patch.yml

kubectl patch configmap/aws-auth -n kube-system --patch "$(cat ./aws-auth-patch.yml)"

Import cloudformation template in AWS portal and run the stack as per instruction

After successful build, run following:

kubectl get services simple-jwt-api -o wide

export TOKEN=`curl -d '{"email":"<EMAIL>","password":"<PASSWORD>"}' -H "Content-Type: application/json" -X POST <EXTERNAL-IP URL>/auth  | jq -r '.token'`

export TOKEN=`curl -d '{"email":"hi@bye.com","password":"welcome"}' -H "Content-Type: application/json" -X POST aaa2118561c5948619a2f0d40672a48c-25561881.us-east-1.elb.amazonaws.com/auth  | jq -r '.token'`

echo $TOKEN

curl --request GET 'aaa2118561c5948619a2f0d40672a48c-25561881.us-east-1.elb.amazonaws.com/contents' -H "Authorization: Bearer ${TOKEN}" | jq
