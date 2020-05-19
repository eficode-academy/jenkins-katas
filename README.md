# Jenkins Kata
Look into the labs folder for exercises

## Open in google cloud shell

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/praqma-training/jenkins-katas.git)

Spin up the Jenkins server by running:
`docker-compose up -d`
Jenkins is running on port 8080

Username: admin
Password: `7p4rk3r4qgp3c2020` without 2020

## Layout of this repository

``` bash
.
├── app                 # The application itself
├── component-test      # Python component test and setup
├── docker-compose.yml  # Jenkins docker-compose file to start jenskins
├── examples            # Examples of the different exercise solutions and more.
├── img                 # Images for the readmes in the labs folder
├── jenkins             # Folder for all the ci specific files
├── labs                # All different exercises in Jenkins
├── LICENSE             # MIT license for the repository
├── README.md           # Front page of the repo
```
