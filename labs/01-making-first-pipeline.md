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
* Connect to GitHub
  * Click `GitHub`
  * Click `Create an access token here`.
  * You are now in GitHub
    * Give it a name over at Github
    * Scroll down to click on `generate token`
    * Copy the token ( via icon )
  * Go back to your Jenkins server
  * Paste the token into Jenkins and click `connect`
  * Choose your private GitHub organization
  * Select the forked repository in your own organization and `create pipeline`
* Make one new stage, called `Say Hello` ( Hint: the `(+)` sign )
* Add a step to the added stage
  * Click `Add step` and select `Shell Script`,
  * Copy-Paste `echo "hello world"` into the text field
  * Click `Save`
* Commit to new branch called `pipeline-editor` -> click `Save & Run`
* Please observe that it runs the stage and step.
  * Note: the `Check out from version control` step was already added when it was connected to GitHub repository.

## Parallel execution

In this part, we are going to run parallel stages.
We are also going to try to compile our code into a binary as well.

### Task

* Click on the `Run` `1` ( that ran the `pipeline-editor` branch )
* Click the `pen` ( `edit`) in upper right corner
* Add a new stage underneath the first one called "build app"
* Under `settings` , choose `docker` as the agent, and write that the image is going to be `gradle:jdk11`
* Click on `Steps` and add a step with shell script, executing `ci/build-app.sh`
* As part of the parallel stage creation the `Say Hello` stage name is also used as the parent stage name. Please rename the parent stage to `Parallel execution` by click the `Say Hello` under the six dots and change the stage name accordingly.
* Click `Save` and follow same commit and run procedure as above

If you see an output like this in the logs, then you have successfully made the assignment:

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
After we have done that, we can download it under the tab called "Artifacts" after each successful build.

### Task

* Add a new step in the build after the Shell script
* Choose the type `Archive the artifacts`, and add the path `app/build/libs/` to the step
* Click `Save` and follow same commit and run procedure as above
* Under the job and tab called "Artifacts", you should see an artifact called "app/build/libs/app-0.1-all.jar"
  * Note: There are also an artifact called `pipeline.log` which contains the total log of the run.

If you do see the artifact, then you are done with the exercise.

> Tip: If you want to see the pipeline that was run, click on the run in Blue Ocean view, click `edit` and press `Ctrl+S`, and Jenkins will display the whole pipeline for you. You also can make changes and let them reload back to the UI.

## Further reading

[Pipeline Syntax](https://jenkins.io/doc/book/pipeline/syntax/) describes the basic syntax of the Declarative Pipeline, including Sections and Directives.

[Pipeline Basic Steps](https://jenkins.io/doc/pipeline/steps/workflow-basic-steps/#stash-stash-some-files-to-be-used-later-in-the-build) Describes the steps that are available to all Jenkins Pipelines

[Pipeline Steps Reference](https://jenkins.io/doc/pipeline/steps/) Links to descriptions of steps provided by plugins.
