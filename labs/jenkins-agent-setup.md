# Jenkins agent setup

In this exercise you will:

* Set up an agent on your host machine
* Set label on the agent and make sure it is used in a job
* Set the agent offline to see the implications in a job

## Tasks

Manage jenkins, manage nodes, new node, permanent agent

![Adding a new agent](../img/new-agent.png)

Root dir: /tmp/jenkins

Host Key Verification Strategy: non verifying verification strategy

IP: 172.17.0.1

Add credentials

![Adding a new cred](../img/add-cred.png)

![Editing the credentials](../img/add-cred2.png)
Assign an ID that can be used to access the credential. The Pipeline uses this ID to apply these
credentials

NB! Remember to install JAVA on the host: `sudo apt update && sudo apt install -y openjdk-11-jdk`

## Choosing who to run your code

### task

Replace `agent any` in your pipeline with the following:

```Jenkins
    agent {
        label 'Host'
    }
```

Run it, and see that the workspace it runs from is the following:

``` logs
[Pipeline] node
Running on Host in /tmp/jenkins/workspace/jenkins-intro
[Pipeline] {
```

## Swarming agents

In the prior way of connecting an agent, we let the master connecting to the node in order to establish the connection.

This can be used in situations where the instances that needs to be added to Jenkins have static IP addresses and are well known.

If that is not the case, like cloud instances etc, it will be benneficial that the nodes makes the initial contact. For that Jenkins provides a plugin they call [swarm](https://wiki.jenkins.io/display/JENKINS/Swarm+Plugin) (not to be confused with Docker Swarm)

### Tasks

Install plugin

Swarm plugin

`wget https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.17/swarm-client-3.17.jar`

`java -jar swarm-client-3.17.jar -master http://172.19.0.2:8080 -username admin -password admin -labels swarm`

Replace `agent any` in your pipeline with the following:

```Jenkins
    agent {
        label 'swarm'
    }
```