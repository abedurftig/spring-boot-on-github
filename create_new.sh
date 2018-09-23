#!/bin/bash

if [ "$GITHUB_USER" = "" ] 
then
    echo "You have to set the GITHUB_USER env var"
    exit 0
fi

if [ "$GITHUB_API_TOKEN" = "" ] 
then
    echo "You have to set the GITHUB_API_TOKEN env var"
    echo "Refer to https://github.com/settings/tokens/new"
    exit 0
fi

echo "-------------------"
echo "Setup a new project"
echo "-------------------"
echo "For more details refer to the spring-io/initializr docs: https://github.com/spring-io/initializr#generating-a-project"
echo "-------------------"

read -e -p "Project name [default: spring-boot-starter]: " PARAM_PROJECT_NAME
[ -z "${PARAM_PROJECT_NAME}" ] && PARAM_PROJECT_NAME="spring-boot-starter"

read -e -p "Comma separated list of dependencies [default: web,actuator]: " PARAM_DEPENDECIES
[ -z "${PARAM_DEPENDECIES}" ] && PARAM_DEPENDECIES="web,actuator"

read -e -p "GroupId [default: org.example]: " PARAM_GROUP_ID
[ -z "${PARAM_GROUP_ID}" ] && PARAM_GROUP_ID="org.example"

read -e -p "Description [default: ]: " PARAM_DESCRIPTION
[ -z "${PARAM_DESCRIPTION}" ] && PARAM_DESCRIPTION=""

read -e -p "Root package [default: $PARAM_GROUP_ID]: " PARAM_DESCRIPTION
[ -z "${PARAM_ROOT}" ] && PARAM_ROOT=$PARAM_GROUP_ID

read -e -p "Java version [default: 1.8]: " PARAM_JAVA
[ -z "${PARAM_JAVA}" ] && PARAM_JAVA="1.8"

read -e -p "Spring Boot version [default: 2.0.6.RELEASE]: " PARAM_BOOT
[ -z "${PARAM_BOOT}" ] && PARAM_BOOT="2.0.6.RELEASE"

echo "-------------"
echo "Review config"
echo "-------------"
echo "-d name=$PARAM_PROJECT_NAME"
echo "-d dependencies=$PARAM_DEPENDECIES"
echo "-d groupId=$PARAM_GROUP_ID"
echo "-d description=$PARAM_DESCRIPTION"
echo "-d packageName=$PARAM_ROOT"
echo "-d javaVersion=$PARAM_JAVA"
echo "-d bootVersion=$PARAM_BOOT"

read -e -p "Are you happy? [Y/n] " HAPPY

if [ "$HAPPY" = "y" ] || [ "$HAPPY" = "Y" ] || [ "$HAPPY" = "" ]
then
    echo "All right. Let's continue..."
else
    echo "Just start over then."
    exit 0
fi

echo "Get starter files from spring.io"
mkdir $PARAM_PROJECT_NAME
cd ./$PARAM_PROJECT_NAME

curl https://start.spring.io/starter.tgz \
-d language=java \
-d type=gradle-project \
-d name=$PARAM_PROJECT_NAME \
-d dependencies=$PARAM_DEPENDECIES \
-d groupId=$PARAM_GROUP_ID \
-d description=$PARAM_DESCRIPTION \
-d packageName=$PARAM_ROOT \
-d javaVersion=$PARAM_JAVA \
-d bootVersion=$PARAM_BOOT | tar -xzvf - &> /dev/null

# echo "Create README"
echo "This project was created with https://github.com/abedurftig/spring-boot-on-github." > README.md

GITHUB_REQUEST_DATA=$(echo '{"name":"$PARAM_PROJECT_NAME", "description":"$PARAM_DESCRIPTION", "gitignore_template":"Gradle"}' | PARAM_PROJECT_NAME=$PARAM_PROJECT_NAME PARAM_DESCRIPTION=$PARAM_DESCRIPTION envsubst)

echo "Create the remote GitHub repository with name $PARAM_PROJECT_NAME"
curl \
-u $GITHUB_USER:$GITHUB_API_TOKEN \
--header "Content-Type: application/json" \
--request POST \
--data $GITHUB_REQUEST_DATA \
https://api.github.com/user/repos &> /dev/null

echo "Init local Git repository"
git init
echo "Setting remote to 'https://github.com/$GITHUB_USER/$PARAM_PROJECT_NAME.git'"
git remote add origin https://github.com/$GITHUB_USER/$PARAM_PROJECT_NAME.git

read -e -p "Do you want to commit and push now? [Y/n] " PUSH

if [ "$PUSH" = "y" ] || [ "$PUSH" = "Y" ] || [ "$PUSH" = "" ]
then
    echo "All right. Let's continue..."
else
    echo "Ok. You can do manually later. Just use."
    echo "git add ."
    echo 'git commit -m "Initial commit"'
    echo "git push -u origin master"
    exit 0
fi

echo "Commit to local repository"
git add .
git commit -m "Initial commit"

echo "Push to the GitHub repository"
git push -u origin master

echo "Done."
