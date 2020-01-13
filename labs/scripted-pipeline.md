# Scripted pipeline

In this exercise you will:

* Get to know the basics of scripted pipeline
* Practice using git branches and committing Jenkinsfile changes
* Examine the difference between scripted and declarative pipeline
* Look at some advanced use cases

## What was scripted pipeline, again?
Scripted pipeline was the first pipeline implementation in Jenkins. It is a DSL based on Groovy, and gives you a lot of freedom and power. It is much closer to writing pure code, and allows you to do almost anything you can imagine. The drawback is that you need to know Groovy in order to use it well, and it is a lot harder to just get started. You can also easily over-complicate your pipelines. The more opinionated declarative pipeline format forces you to follow mostly sane conventions.

## Creating a simple scripted pipeline
Here is a declarative pipeline that looks a lot like the one we created in the first exercises:
```groovy
pipeline {
    agent any
    stages {
        stage('Parallel stuff') {
            parallel {
                stage('say hello') {
                    steps {
                        echo "Hello world"
                    }
                }

                stage('build app') {
                    agent {
                        docker {
                            image 'gradle:jdk11'
                        }
                    }
                    steps {
                        sh 'ci/build-app.sh'
                        archiveArtifacts 'app/build/libs/'
                    }
                }
            }
        }
    }
}
```

Up until now, we have made most changes to our pipeline through the Jenkins UI. In this exercise, we will change the Jenkinsfile directly, and commit the result ourselves.

### Task
Make sure you have completed the `Making your first pipeline` and `Editing your pipeline` exercise. You will already have a Jenkinsfile in your repository, and a job on the Jenkins server that executes whenever the Jenkinsfile is changed.
* Replace the contents of your `Jenkinsfile` with the declarative pipeline above.
* Commit the change, and push it to GitHub:
```bash
# Prepare our changes to be commited
$ git add Jenkinsfile

# Commit our change and give it a meaningful commit message
$ git commit -m "Updated Jenkinsfile to match the example in scripted-pipeline exercise"

# Push our commit to GitHub
$ git push
```
* Go to Jenkins and confirm that the job is running as expected


Now that we have our declarative pipeline up and running, let's have a look at the same pipeline. This time, we have written it as a scripted pipeline:
```groovy
node { 
    stage('Parallel stuff') {
        parallel (
            "Say hello" : {
                stage ('Say hello') {
                    echo "hello"
                }
            },
            "build app" : {
                docker.image('gradle:jdk11').inside {
                    stage('Test') {
                        git 'https://github.com/praqma-training/jenkins-katas.git'
                        sh 'ci/build-app.sh'
                        archiveArtifacts 'app/build/libs/'
                    }
                }
            }
        )
    }
}
```

As you can see right away, the difference is not huge. Apart from the minor differences in syntax, the only real difference is that we have to manually specify where we want to check out source code. In declarative pipeline, checkout happens automatically unless we specifically configure a stage *not* to.

Let us create a new branch in our git repository, so that we can modify the Jenkinsfile and compare:
### Task
* Create a new git branch, then replace the contents of your `Jenkinsfile` with the scripted pipeline snippet above. Commit the change, then push your new branch to Github:
```bash
# Create a new local branch
$ git branch scripted-pipeline-branch

# Checkout your new branch
$ git checkout scripted-pipeline-branch

# Now you replace the contents of Jenkinsfile with the scripted pipeline above

# Prepare our changes to be committed
$ git add Jenkinsfile

# Commit our change to the local branch and give it a meaningful commit message
$ git commit -m "Updated Jenkinsfile to be scripted"

# Push our new branch to github
$ git push --set-upstream origin scripted-pipeline-branch
```
* Go to Jenkins and find the `scripted-pipeline-branch` job. Since we already have a multi-branch Jenkins job set up, it will only take about a minute to pick up the new branch, create a job from the Jenkinsfile, and schedule the first run of it.
* Have a look at the build of the scripted job. Did it work in the same way? Did it succeed?
* Try to use Jenkins pipeline editor to edit the scripted pipeline. What happens?


## Making the pipeline more advanced

It's time to expand our pipeline. Since we are using docker containers, it is very cheap to use different environments. Let's say we want to run our test suite with different java versions: 

### Task
* Go back to your master branch, where the declarative pipeline is: 
```bash
$ git checkout master
```
* Add 2 new stages to your Jenkinsfile. They should be identical to the existing test stage, but instead of `gradle:jdk11`, they should use `gradle:jdk8`and `gradle:jdk13`.
> Hint: You should give your new stages different names, so you can tell them apart in Jenkins.
* When you are done adding the stages, use `git add Jenkinsfile`, `git commit -m "Testing with more java versions"` and `git push` to push your change to Github so Jenkins can pick it up.
* Go to Jenkins and watch how your tests run with different Java versions. Looks like we are not supporting jdk13. Good to know!

Let's add the same functionality to our scripted pipeline. There are many different ways you can do it - using methods, or doing it in-line. Remember, it's just programming.
You are welcome to try yourself, but this is not a Groovy programming course, so we will also provide a solution right away. Remember to `git checkout scripted-pipeline-branch` before you modify your Jenkinsfile.
```Groovy
// Create an empty map that will contain our stages
def mapOfStages = [:]

// Manually add the "hello" stage
mapOfStages["hello"] = {
    stage ('Say hello') {
        echo "hello"
    }
}

// Use a foreach loop to create one stage per entry in the dockerImages list
def dockerImages = ["gradle:jdk8","gradle:jdk11","gradle:jdk13"]
dockerImages.each {
    // "${it}" is the iterator pointing to the current entry. So we dynamically insert, for instance, "gradle"jdk8" in all the places in the stage where it makes sense
    mapOfStages["${it}"] = { 
        docker.image("${it}").inside {
            stage("${it}") {
                lock ('checkoutLock') { // We use a "lock" built into Jenkins, to make sure only one parallel step is doing this at a time. Checking out code in parallel in scripted pipelines is not completely thread-safe...
                    git 'https://github.com/praqma-training/jenkins-katas.git'
                }
                sh 'ci/build-app.sh'
                archiveArtifacts 'app/build/libs/'
            }
        }
    }
}

// This is where we execute the map of stages that we have built
node { 
    stage('Parallel stuff') {
        parallel mapOfStages
    }
}
```

This pipeline is much harder to read. However, it saves us from writing the same piece of stage declaration many times. Imagine the length of our declarative pipeline if we had to test with 15 java versions. With this script we can just add more images to the `dockerImages` map and call it a day.

> Good to know: The [matrix directive](https://jenkins.io/blog/2019/11/22/welcome-to-the-matrix/) will soon be added to stable Jenkins, and will make it much simpler to run the same pipeline steps with different parameters. In general, a lot of development is happening that makes declarative pipeline easier and easier to use.


### Tasks
* Checkout the scripted branch: `git checkout scripted-pipeline-branch`, paste the pipeline above into your Jenkinsfile, then `git add`, `git commit -m "Advanced scripted pipeline stuff"` and `git push`, to get the change to GitHub.
* Have a look at Jenkins. Confirm that the result is identical to your declarative pipeline.
* Think about the differences between the declarative and scripted pipelines. What are the strengths and shortcomings of each?


## Good to know: Adding a script block to declarative pipelines
There is a happy "hack" that you can use if you ever need just a little bit of script in your pipeline. You can always create a `script {}` block and write code in there, in the middle of a pipeline.

Let's say we quickly want to do some advanced flow control - like a `try/catch`. We can add that to a declarative pipeline like this:
```Groovy
pipeline {
    agent any
    stages {
        stage('get kernel') {
            steps {
                // Use a script block to add a try/catch block
                script {
                    try {
                        KERNEL_VERSION = sh (script: "uname -r", returnStdout: true)
                    } catch (err) {
                        echo "Caught error ${err}..."
                    }
                }
            }
        }
        stage('say kernel') {
            steps {
                echo "${KERNEL_VERSION}"
            }
        }
    }
}
```

## Good to know: Using scripted pipeline to create steps that can be used in your declarative pipelines
[Shared libraries](https://jenkins.io/doc/book/pipeline/shared-libraries/) is where you should put complicated scripted pipeline code, and turn it into `steps` that can be used in your declarative pipelines. This allows you to use the power of scripted pipeline while keeping your declarative pipelines clean and simple.

## Extra task
If you are done with the exercise and you are feeling brave, try writing some more elaborate code in your scripted pipeline. You have basically unrestricted access to the Groovy programming language (which is based on Java), so anything is possible!

You can also add a `script {}` block to your declarative pipeline. Try to make something cool happen!

## Further reading
* [Scripted pipeline syntax](https://jenkins.io/doc/book/pipeline/syntax/#scripted-pipeline) explains the use cases and functionality of scripted pipeline.
* [Shared libraries](https://jenkins.io/doc/book/pipeline/shared-libraries/) As mentioned above, is where you can define declarative steps for reuse across pipelines.
