#!/bin/sh

ECR_URL="821302506864.dkr.ecr.eu-west-1.amazonaws.com/notejam"

productVersion=$(cat VERSION)
buildId=$(date +%s)
assemblyVersion="${productVersion}.${buildId}"
localImage="notejam:latest"

echo $productVersion
echo $assemblyVersion

# TODO: add arguments
docker build -t ${localImage} .
docker tag ${localImage} ${ECR_URL}:${assemblyVersion}
docker push ${ECR_URL}:${assemblyVersion}

# TODO: from master promote to ${productVersion}
# TODO: PR to master promote to ${productVersion}-rc

docker tag ${localImage} ${ECR_URL}:${productVersion}
docker push $ECR_URL:$productVersion
