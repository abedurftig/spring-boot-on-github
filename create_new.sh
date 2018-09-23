echo "Call start.spring.io"
curl https://start.spring.io/starter.zip -o $GITHUB_NAME.zip
unzip -d $GITHUB_NAME $GITHUB_NAME.zip
cd ./$GITHUB_NAME

GITHUB_REQUEST_DATA=$(echo '{"name":"$GITHUB_NAME", "gitignore_template":"Gradle"}' | envsubst)
echo "POST request data"
echo $GITHUB_REQUEST_DATA

echo "POST request"
curl \
-u $GITHUB_USER:$GITHUB_API_TOKEN \
--header "Content-Type: application/json" \
--request POST \
--data $GITHUB_REQUEST_DATA \
https://api.github.com/user/repos

echo "Local git repo"
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/$GITHUB_USER/$GITHUB_NAME.git
git push -u origin master

echo "Done."
