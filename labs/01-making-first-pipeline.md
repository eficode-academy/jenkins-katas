# Making your first pipeline

In this exercise you will:

* Create and run a pipeline via the pipeline editor
* Edit the pipeline to run parallel stages
* Get a downloadable artifact in the end

## The pipeline editor

Make a pipeline with the pipeline editor

### Task

* Open Blue Ocean (Click the link on the left hand side that says 'Open Blue Ocean')
* Create a new pipeline
* Click `GitHub` -> click on the `Create an access token here.` -> Give it a name in Github, and scroll down to click on "generate token" -> Paste the token into Jenkins and click connect -> choose your private GitHub organization -> select the forked repository and "create pipeline"
* Make one new stage, called "say hello"
* Add a step with the `shell script` step type, where it executes `echo "hello world"`
* Click save
* Commit to new branch called `pipeline-editor` -> click save and run
* Click on the job, observe that it runs and examine the step results

## Parallel execution

In this part, we are going to run parallel stages.
We are also going to try to compile our code into a binary as well.

### Task

* Go back into the pipeline editor by clicking the pencil symbol at the top of the page
* Add a new stage underneath the first one and name it "build app"
* Under Settings (bottom of page), choose "docker" as the agent, and in the image field enter "gradle:jdk11"
* Click on steps and add a step with shell script, executing `ci/build-app.sh`
* Click save
* Commit to the same branch as before called `pipeline-editor` -> click save and run
* Click on the job, observe that it runs and examine the step results

If you see an output like this in the logs, then you have successfully concluded this part of the excercise:

```bash
+ ci/build-app.sh


Welcome to Gradle 6.0.1!

....

BUILD SUCCESSFUL in 29s

4 actionable tasks: 3 executed, 1 up-to-date

```

## Archiving the result

In the section above, we compiled our code into a binary, but it is not easily accessible from Jenkins interface yet.
For that we need to "archive" it.
After we have done that, we can download it under the tab called "artifacts" after each successfull build.

### Task

* Go back into the pipeline editor by clicking the pencil symbol at the top of the page
* Add a new step in the build after the `build app` shell script
* Choose the type "Archive the artifacts", and add the path `app/build/libs/` to the step
* Save, commit and run as you did in the exercise before
* Under the job and tab called "Artifacts", you should see an artifact called "app/build/libs/app-0.1-all.jar"

If you do see the artifact, then you are done with the exercise.

> Tip: If you want to see the pipeline code that was executed, click on the job and go into the pipeline editor and press Ctrl+S. Jenkins will display the pipeline code, where you can make changes and let them reload back to the UI.

## Further reading

[Pipeline Syntax](https://jenkins.io/doc/book/pipeline/syntax/) describes the basic syntax of the Declarative Pipeline, including Sections and Directives.

[Pipeline Basic Steps](https://jenkins.io/doc/pipeline/steps/workflow-basic-steps/#stash-stash-some-files-to-be-used-later-in-the-build) Describes the steps that are available to all Jenkins Pipelines

[Pipeline Steps Reference](https://jenkins.io/doc/pipeline/steps/) Links to descriptions of steps provided by plugins.
