# Editing your pipeline

In the previous exercise, we used the GUI to
create our pipeline. Although it is helpful and
will help you get started, normally we need to
edit the script by hand to better utilize the
pipeline. In this exercise you will:

- Sets a build trigger to run every minute, so you
  do not have to manually activate the build
  trigger.
- Use the "Replay" feature for fast iteration of
  build steps.
- Use different agents for building steps
- Use stash and unstash for sending your data from
  one agent or step to another
- Use the built-in test report plugin as a post
  step to show reports of Unit tests for each
  build.
- Append a clean up step that always runs, no
  matter the status of the other stages.

## Set build trigger

When using the BlueOcean UI, what actually happens
when you click "save and run" is the following:

Jenkins will

- make a commit with the new version of the
  pipeline
- push the new commit to the branch you were
  working on.
- after a successful push, trigger a build.

When making the changes on you own machine,
Jenkins does by default not know if there is a new
commit being pushed to git. Therefore we need to
add a repository trigger to the job.

### Tasks

- Go in to the old UI of Jenkins
- Make sure you are at the root level of the
  jenkins-katas job
- click configure
- Scroll down to `Scan Repository Triggers` and
  select `Periodically if not otherwise run`
- Under `Interval` choose `1 minute`
- Click `save`

Now Jenkins will ask github for changes every
minute, and trigger if there is any.

## Replay an old pipeline

Typically a Pipeline will be defined inside of the
classic Jenkins web UI, or by committing to a
`Jenkinsfile` in source control.

Unfortunately, neither approach is ideal for rapid
iteration, or prototyping, of a Pipeline.

The "Replay" feature allows for quick
modifications and execution of an existing
Pipeline without changing the Pipeline
configuration or creating a new commit.

### Tasks

We want to clean up after our run, deleting the
workspace.

To use the "Replay" feature:

Currently the Replay feature is not available
using the Blue Ocean ui, so we use the classic ui.

- Select a previously completed run in the build
  history.
- In the upper right corner click the 'exit' icon
  labeled 'Go to classic'.
- You should now have a different ui showing the
  same build.
- Click **Replay** in the left menu.
- You can now make changes to the pipeline code.
- Make modifications to the end of the `build app`
  stage: first list the contents of the workspace,
  then use the `deleteDir()` keyword to delete the
  workspace, and finally list the content again
  after the deletion, to verify that they were
  deleted.
  - If you get stuck figuring out the declarative
    syntax, see the following section
    [`Getting help from Jenkins`](#getting-help-from-jenkins).
- Click **Run**.
- Check the results of changes

Once you are satisfied with the changes, you can
use **Replay** to view them again, copy them back
to your Pipeline job or `Jenkinsfile`, and then
commit them using your usual engineering
processes.

> Note: If you created your pipeline through Blue
> Ocean GUI to your forked repository, it
> automatically created a `Jenkinsfile` to the
> root of your repository. This Jenkinsfile is the
> code you see when you use the "Replay"
> functionality. If you do a `git pull` on your
> terminal, you should see your Jenkinsfile
> updated if you make changes to your pipeline
> with the Blue Ocean GUI.

## Getting help from Jenkins

There are two different code generators in Jenkins
when using the classical UI.

- **Snippet generator** is there to help you make
  the right syntax for the different steps inside
  a job.
- **Declarative Directive Generator** is there to
  help you make the right syntax for the structure
  of the job itself, with agents, parallel runs
  etc.

> Note: the pipeline editor in Blue Ocean combines
> both of the generators into one more easily
> useable tool. The snippet generator does have
> it's merits as a help for the syntax itself when
> you are editing the pipeline on your computer.

To generate a step snippet with the Snippet
Generator:

- Navigate to the Pipeline Syntax link from a
  configured Pipeline, or at
  `http://<your hostname>/pipeline-syntax`.
- Select the desired step in the Sample Step
  dropdown menu
- Use the dynamically populated area below the
  Sample Step dropdown to configure the selected
  step.
- Click Generate Pipeline Script to create a
  snippet of Pipeline which can be copied and
  pasted into a Pipeline.

> Note: As most stuff in Jenkins are actually open
> source plugins with thousands of different
> people maintaining them, few steps don't have
> all options available through the snippet
> generator even though they still work.

## Building on different machines

It's common to have different types of hardware to
run your pipeline. Some things can be done on
inexpensive low performance hardware, while other
things require extra RAM, or a specific piece of
hardware to be run on.

This is achieved by agent labels depicting which
of the agents this particular step should be run
on.

When we transfer our job from one agent to
another, we usually also need to transfer our
repository data along with other already made
binaries.

> Note: every time you change agent (both node and
> docker agent), Jenkins will clone down the
> repository again. If you do not want that, you
> need to add the option
> [skipDefaultCheckout(true)](https://jenkins.io/doc/book/pipeline/syntax/#options)
> to the stages that does not need this option, or
> in the
> [stages part in the top](https://jenkins.io/blog/2018/04/09/whats-in-declarative/#new-options)

### Tasks

We want a pipeline that on the stages looks like
this: ![Stages](../img/stages02.png)

- Make a new stage called `clone down`.
- Make that stage run on the agent with a node
  that has the label `swarm`.
- Inside that stage, make a `stash` step that
  excludes the .git folder, and has the name
  "code".
- In the stage `build app`, add the
  `skipDefaultCheckout(true)` option.
- Add a new first step where you unstash your
  "code" stash.
- Run the pipeline and see that the build still
  runs.
- If you do not have any nodes with that label
  attached, it will just wait forever.
- If that is the case, change the label in the job
  to `master-label` which should be the label of
  the node embedded in your master.

## Test reporting

Running a Gradle test and display the result.

With `Preparation` now being done, we need to
build the code and store the result. For each of
the bullet points, try to build it to make sure it
works before moving to the next.

### Tasks

- Add a new stage in parallel to `build app`,
  called `test app` by copying `build app` and
  deleting its steps excluding `unstash 'code'`.
- Call the shell script `ci/unit-test-app.sh` to
  run the unit tests made.
- In order for you to get the unit tests out in
  the UI, add another step with the following;
  `junit 'app/build/test-results/test/TEST-*.xml'`.
- Click on the "Tests" tab to see the result.

## Post steps

As a post step, you can get Jenkins to clean up
after itself, thereby only leaving the artifact
stored in last lab.

### Tasks

Just after the `stages` block ends, append the
following to make Jenkins clean up after itself.

```Jenkins
post {
    cleanup {
        deleteDir() /* clean up our workspace */
    }
}
```

That's it!
