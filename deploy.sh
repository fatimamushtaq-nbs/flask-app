# Install AWS Command Line Interface
# https://aws.amazon.com/cli/
apk add --update python python-dev py-pip
pip install awscli --upgrade

docker pull $CONTAINER_RELEASE_IMAGE

# Set AWS config variables used during the AWS get-login command below
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_ECR_ACCESS_KEY=$AWS_ECR_ACCESS_KEY
export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
# Log into AWS docker registry
# The `aws ecr get-login` command returns a `docker login` command with
# the credentials necessary for logging into the AWS Elastic Container Registry
# made available with the AWS access key and AWS secret access keys above.
# The command returns an extra newline character at the end that needs to be stripped out.

#eval $(aws ecr get-login --no-include-email --region $AWS_REGION | tr -d '\r')
#eval $(aws ecr get-login --no-include-email --region $AWS_REGION | sed 's|https://||')\
docker login -u AWS -p $AWS_ECR_ACCESS_KEY 405484047798.dkr.ecr.us-east-1.amazonaws.com

# Push the updated Docker container to the AWS registry.
# Using the \$CI_ENVIRONMENT_SLUG variable provided by GitLab, we can use this same script
# for all of our environments (production and staging). This variable equals the environment
# name defined for this job in gitlab-ci.yml.

docker tag $CONTAINER_RELEASE_IMAGE $AWS_ECR_REPO
docker push $AWS_ECR_REPO

# The AWS registry now has our new container, but our cluster isn't aware that a new version
# of the container is available. We need to create an updated task definition. Task definitions
# always have a version number. When we register a task definition using a name that already
# exists, AWS automatically increments the previously used version number for the task
# definition with that same name and uses it here. Note that we also define CPU and memory
# requirements here and give it a JSON file describing our task definition that I've saved
# to my repository in a aws/ directory.

#aws ecs register-task-definition --family flaskapp-$CI_ENVIRONMENT_SLUG --requires-compatibilities FARGATE --cpu 256 --memory 512 --cli-input-json file://aws/webcaptioner-task-definition-$CI_ENVIRONMENT_SLUG.json --region $AWS_REGION

# Tell our service to use the latest version of task definition.
aws ecs update-service --cluster default --service flaskaap-serv --task-definition flaskapp-deploy --region $AWS_REGION