#!/bin/sh

ECR_URL="xxxxxxxxxxxx.dkr.ecr.eu-west-1.amazonaws.com/notejam"

productVersion=$(cat VERSION)
buildId=$(date +%s)
assemblyVersion="${productVersion}.${buildId}"
localImage="notejam:${productVersion}"

echo $productVersion
echo $assemblyVersion

# TODO: add arguments
docker build \
  --build-arg PRODUCT_VERSION=$productVersion \
  --build-arg ASSEMBLY_VERSION=$assemblyVersion \
  -t ${localImage} .
docker tag ${localImage} ${ECR_URL}:${productVersion}
docker push ${ECR_URL}:${productVersion}
