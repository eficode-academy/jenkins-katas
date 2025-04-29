# Making your first pipeline

In this exercise you will:

* Create and run a pipeline via the pipeline editor
* Edit the pipeline to run parallel stages
* Get a downloadable artifact in the end

## The pipeline editor

Make a pipeline with the pipeline editor

### Task

* Open Blue Ocean (Click the link on the left hand side that says 'Open Blue Ocean').
* Create a new pipeline.
* Connect to GitHub.
  * Click `GitHub`.
  * Click `Create an access token here`.
  * You are now in GitHub.
    * Give it a name.
    * Scroll down and click on `generate token`.
    * Copy the token ( via icon ).
  * Go back to your Jenkins server.
  * Paste the token into Jenkins and click `Connect`.
  * Choose the GitHub organization that has the forked repository.
  * Select the forked repository and `Create pipeline`.
* Make a new stage, called `Say Hello` ( Hint: the `(+)` sign ).
* Add a step to the added stage.
  * Click `Add step` and select `Shell Script`,
  * Copy-Paste `echo "hello world"` into the text field.
  * Click `Save`.
* Choose Commit to master -> click `Save & Run`.
* Please observe that it runs the stage and step.
  * Note: the `Check out from version control` step was already added when it was connected to GitHub repository.


## Github auth

We need to add the credentials to the repository for GitHub access, otherwise we will end up rate limited really fast:

1. Navigate to your pipeline in Blue Ocean
2. Click on "Pipeline settings" (gear icon) in the top right corner
3. Select "Configure" from the dropdown menu
4. Scroll to the "Branch Sources" section
5. Find your GitHub repository configuration
6. For "Credentials", click the dropdown and select "Add" > "Jenkins"
7. In the new modal:
   - Kind: Select "Username with password" or "Username with token"
   - Username: Your GitHub username
   - Password/Token: Paste your GitHub personal access token
   - ID: Leave blank or provide a meaningful name like "github-repo-credentials"
   - Description: "GitHub Repository Access"
8. Click "Add" to save these credentials
9. Select your newly created credentials from the dropdown
10. Click "validate" to check that it works.
11. if yes, click "Save" at the bottom of the page

This repository-level authentication ensures that Jenkins can properly access this specific repository for checking out code, creating webhooks, and other repository operations.

## Parallel execution

In this part, we are going to run parallel stages.
We are also going to try to compile our code into a binary as well.

### Task

* Navigate to your pipeline in Blue Ocean
* Click on the `Build`.
* Click the `pen` ( `edit`) in upper right corner.
* Add a new stage underneath the first one called "build app".
* Under `settings` (lower right corner ), choose `docker` as the agent, and write `gradle:6-jdk11` in the image.
* Add a shell script step which execute this: `ci/build-app.sh`.
* As part of the parallel stage creation the `Say Hello` stage name is also used as the parent stage name. Please rename the parent stage to `Parallel execution` by click the `Say Hello` under the six dots and change the stage name accordingly.
* Click `Save` and follow same commit and run procedure as above.

If you see an output like this in the logs, then you have successfully concluded the excercise:

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

* Add a new step in the `Build app` stage after the Shell script.
* Choose the type `Archive the artifacts`, and add the path `app/build/libs/` to `Artifacts` field.
* Click `Save` and follow same commit and run procedure as above.
* Under the build and tab called "Artifacts", you should see an artifact called "app/build/libs/app-0.1-all.jar".
  * Note: You can also find the `pipeline.log` here. It is a total log of the whole build including all stages and steps.

If you do see the artifact, then you are done with the exercise.

> Tip: If you want to see the pipeline that was run, click on the build in Blue Ocean view and press Ctrl+S, and Jenkins will display the whole pipeline for you, where you also can make changes and let them reload back to the UI.

## Further reading

[Pipeline Syntax](https://jenkins.io/doc/book/pipeline/syntax/) describes the basic syntax of the Declarative Pipeline, including Sections and Directives.

[Pipeline Basic Steps](https://jenkins.io/doc/pipeline/steps/workflow-basic-steps/#stash-stash-some-files-to-be-used-later-in-the-build) Describes the steps that are available to all Jenkins Pipelines

[Pipeline Steps Reference](https://jenkins.io/doc/pipeline/steps/) Links to descriptions of steps provided by plugins.
