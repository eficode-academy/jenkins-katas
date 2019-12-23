# making your first pipeline

In this exercise you will:

* Create and run a pipeline via the pipeline editor
* Edit the pipeline to run parallel stages
* Get a downloadable artifact in the end

## The pipeline editor

Make a pipeline with the pipeline editor

### Task

* Open Blue Ocean (Click the link on the left hand side that says 'Open Blue Ocenan')
* Create a new pipeline
* Click `GitHub` -> click on the `Create an access token here.` -> Give it a name over at Github, and scroll down to click on "generate token" -> Paste the token into Jenkins and click connect -> choose your private GitHub organization -> select the forked repository and "create pipeline"
* Make one new stage, called "say hello"
* Add a step with the shell script, where it executes `echo "hello world"` (TODO: Not really clear on how you get here, the UI in Blue Ocean is pretty terrible when it comes to navigation)
* click save
* commit to new branch called `pipeline-editor` -> click save and run
* click on the job and observe that it runs.

## Parallel execution

In this part, we are going to run parallel stages.
We are also going to try to compile our code into a binary as well.

### Task

* Add a new step underneath the first one called "build app" 
* Under settings, choose "docker" as the agent, and write that the image is going to be "gradle:jdk11"
* Click on steps and add a step with shell script, executing `jenkins/build-app.sh`
* click save
* commit to the same branch as before called `pipeline-editor` -> click save and run
* click on the job and observe that it runs.

If you see an output like this in the logs, then you have successfully made the assignment:

```bash
+ jenkins/build-app.sh


Welcome to Gradle 6.0.1!

....

BUILD SUCCESSFUL in 29s

4 actionable tasks: 3 executed, 1 up-to-date

```

## archiving the result

In the section above, we compiled our code into a binary, but it is not easily accessible from Jenkins interface yet.
For that we need to "archive" it.
After we have done that, we can download it under the tab called "artifacts" after each successfull build.

### Task

* add a new step in the build after the Shell script
* Choose the type "Archive the artifacts", and add the path `app/build/libs/` to the step
* Save, commit and run as you did in the exercise before
* Under the job and tab called "Artifacts", you should see an artifact called "app/build/libs/app-0.1-all.jar"

If you do see the artifact, then you are done with the exercise.

> Tip: If you want to see the pipeline that was run, click on the job in Blue Ocean view and press Ctrl+S, and Jenkins will display the whole pipeline for you, where you also can make changes and let them reload back to the UI.

## Further reading

[Pipeline Syntax](https://jenkins.io/doc/book/pipeline/syntax/) describes the basic syntax of the Declarative Pipeline, including Sections and Directives.

[Pipeline Basic Steps](https://jenkins.io/doc/pipeline/steps/workflow-basic-steps/#stash-stash-some-files-to-be-used-later-in-the-build) Describes the steps that are available to all Jenkins Pipelines

[Pipeline Steps Reference](https://jenkins.io/doc/pipeline/steps/) Links to descriptions of steps provided by plugins.
