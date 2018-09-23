## What is contained?

Create and push a new Spring Boot project to GitHub.

- Use the `spring-io/initializr` to create the Spring Boot project
- Use the GitHub REST Api to create a remote repository on GitHub
- Initialize a local Git repository and push it to the new GitHub repository

### Setup

- Create a `Personal API Token` in your GitHub account (https://github.com/settings/tokens/new)
- Define an env variable `GITHUB_API_TOKEN` and set it to the `Personal API Token`
- Define an env variable `GITHUB_USER` and set it to your GitHub username

### Run it

```
https://raw.githubusercontent.com/abedurftig/spring-boot-on-github/master/create_new.sh | sh
```
The script will guide through some basic configuration for the generated Spring Boot project.

### Resources

- https://github.com/spring-io/initializr
- https://developer.github.com/v3/
- https://github.com/settings/tokens/new
