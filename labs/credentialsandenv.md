# Credentials and environment variables

## Authenticate Jenkins to Docker Hub

We want to make Jenkins talk to DockerHub, in order for it to push your build Docker images to your repositories.

In order to do that, we need to set up a username and password credentials for the Jenkins server.

### Tasks

> Prerequisite: You need a login to Docker Hub. If you do not already have that, head over to https://hub.docker.com/ and create one to use

* Add your credentials by opening your Jenkins server, and clicking `manage jenkins` on the left pane.
* Click `Manage Credentials`.
* Click `(global)` and `Add credentials`.
* Choose Kind "Username with password".
* Type in your username and password.
* In the ID section, call it "docker_login". This is the ID you will reference back in your pipeline afterwards.
* Click OK.

## Adding docker push to your pipeline

We want our pipeline to push our new docker image up to dockerhub every time we push a new set of commits.
For this we need to use the credentials just made.
Our scripts needs two things:

* An environment variable called `docker_username` that is your username for docker hub. This environment variable is used in the scripts in `ci` folder.
* A set of credentials to make your pipeline login to Docker Hub.

In the exercise you are both going to make a global environment variable, and a set of credentials only accessable to that particular stage that needs them.

### tasks

* add an environment that spans the whole pipeline with the name `docker_username` and your username as value.

> hint: If you want to see an example on how to do this, look at this [example](https://jenkins.io/doc/book/pipeline/jenkinsfile/#setting-environment-variables).

* In your ´build-app´ stage, make a stash after you have called ´ci/build-app.sh´, so that you stash the artifact. The stash name should be the same as before; `code`
* add a **new** stage after the `test app` stage (not in parallel) called `push docker app`. It should have the following code in order to work:

``` Groovy
environment {
      DOCKERCREDS = credentials('docker_login') //use the credentials just created in this stage
}
steps {
      unstash 'code' //unstash the repository code
      sh 'ci/build-docker.sh'
      sh 'echo "$DOCKERCREDS_PSW" | docker login -u "$DOCKERCREDS_USR" --password-stdin' //login to docker hub with the credentials above
      sh 'ci/push-docker.sh'
}
```

* Commit this and push it to see the result.
* Look at the logs of the build to see the usage of credentials. Are your credentials visible in the log?
* Log into Docker hub to see if you have gotten a new repository with a micronaut-app image.

> note: If you wonder why the script works, even though you do not set DOCKERCREDS_PSW directly, then look at this example and explanaition: https://jenkins.io/doc/book/pipeline/jenkinsfile/#usernames-and-passwords

## Extra exercise: user input

Couldn't it be nice if Jenkins asked before pushing to Docker hub?
Try to see what you can implement with the [Input step](https://jenkins.io/doc/pipeline/steps/pipeline-input-step/).

## Extra Extra exercise: Authenticate Jenkins to Github, the manual way

> This guide is for when you cannot use the Blue Ocean way of connecting Jenkins to GitHub through access token. If you are part of a training course, this is not needed unless told otherwise.

We want to make Jenkins talk to GitHub, in order for it to push and pull from your repositories. In order to do that, we need to set up an SSH key for the Jenkins server.

Tasks:

* Generate a new SSH key that will be used by Jenkins to prove itself to GitHub, by following the first part of [Generating a new SSH key](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/).
* Add the public-key to your GitHub account by following [Adding a new SSH key to your GitHub account](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/).
* Add the private-key to Jenkins, by opening your Jenkins server, and clicking `Credentials`
* Click `(global)` and `Add credentials`.
* Choose Kind "SSH Username with private key", write the details used to generate the keypair and paste the contents from the private-key you generated in the first step, (default ~/.ssh/id_rsa).
      write the passphrase you chose.
* Save it.
