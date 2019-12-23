

## 0. Fork the repo and clone it down on your machine



## 2. Create a job

Everything Jenkins can help us with is within a job. It is where we will describe the build and test processes.

### Tasks

* Go into your Jenkins server and click on the `New Item` button on the left.
* Name your new job "#team# gilded rose" and choose `Pipeline` and click OK
* Head down to the `Pipeline` section of the job, and click on the "try sample pipeline" and choose `Hello world`
* Save and Build it.

The result should very well be that you have a blue (successful) build. Verify in Console that hello world was printed out.


## 3. Link Jenkins with your repo

It's a tad overkill to install Jenkins just to print `hello-world`. 
So we would like Jenkins to clone down the repo we have to build and test the software.

### Tasks

* Click the `configure` button in the job
* Scroll to the pipeline section
* In the `definition`, select `Pipeline script from SCM`
* Add the url to your newly forked repository
* Set the branch to */trondheim
* Save
* Build
* Expect the unexpected!

## 4 make Jenkins trigger on changes from github

You want Jenkins to only trigger when you have something new to trigger on.

### Tasks

* Go to the settings section of your repo
* Select webhooks
* Create a new webhook. The url will be yourIp:8080/github-webhook/

* Go to your Jenkins server
* Configure your job
* At the trigger section, select `GitHub hook trigger for GITScm polling`
* Save

## 5. make stages

Edit the Jenkinsfile on your newly forked repository (Feel free to clone it to your own machine. This way you can use a proper IDE)
Make three stages:

* `Preparation`
* `Build`
* `Results`

each of the states should have part saying `echo "stage name"`

Find the decalarative syntax [here](https://jenkins.io/doc/book/pipeline/jenkinsfile/).

Commit and push your changes

Go to the Jenkins server and see if the job was triggered, and all three stages are present in the UI afterwards.

## 6. Running a Gradle test and archiving

With `Preperation` now being done, we need to build the code and store the result.
For each of the bullit points, try to build it to make sure it works before moving to the next.

* In your `Build` stage,  execute `./gradlew clean test jar`
* In your `Results` stage, make jUnit display the results of `**/build/test-results/test/TEST-*.xml` (lookup jUnit in the pipeline syntax if needed)
* Also in your `Results` stage, `archive` the generated jar file in the `build/libs` folder

The archiving part can be verified by looking for a small blue arrow next to the build number in the overview. Make sure you get your Jar file with you there.


## Xtra. Parallel and stashing

We also need to get the javadoc generated for the project.

Fortunately that can be done with a small `./gradlew javadoc` command.

* Create another stage called `Javadoc` where you execute the above command, and archive the result in the `build/docs/javadoc` folder.

Now we have two processes that actually can be run in parallel. The `build` and `javadoc` steps both take in the sourcecode and produces artifacts. So lets try to run them in parallel.

> This assignment is loosely formulated, so you need to [look things up yourself](https://jenkins.io/doc/pipeline/steps/) in order to complete this one

* Stash the source code cloned in `Preparation` and call it source
* `build` and `javadoc` steps needs to be included in a parallel step like the one below

* Unstash the source code in both stages, and perform the normal build steps
* Stash the results instead of archiving. Call them `jar` and `javadoc`
* Unstash them in the `Results` step in the end where you archive them.
