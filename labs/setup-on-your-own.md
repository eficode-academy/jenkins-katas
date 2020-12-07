# Create and setup a Jenkins server

## Initial start

In order for us to start using Jenkins, we need a
Jenkins server. Most Linux distributions have it
in their own package repository, or you can
download it directly from
[Jenkins.io](https://jenkins.io/download/).

In this exercise, we are going to spin up a
Jenkins instance through
[Docker](https://www.docker.com/) and
docker-compose.

Make sure that you do not have anything listening
on port 8080, in case there are any existing
docker container from other exercises. (_docker ps
will help you see if any container is occupying
the port_)

## Actual Setup

First do the tasks in
[start jenkins](./labs/00-start-jenkins.md), so
you have your own fork, and clone it on your
instance (machine).

After that do the following to start Jenkins:

On the instance `cd` into the repository folder
and into `setup` folder.

- Set the admin password to something only you
  know. It is stored in the folder `secret` and is
  called admin.txt. You can use nano for changing
  the content of the file.

- Run `docker-compose up -d` to run the jenkins
  docker image
- Examine that the container is starting by
  issuing a `docker-compose ps` and see that the
  state of the container is `up` like the below
  example

```bash
$ docker-compose ps
       Name                      Command               State                        Ports
---------------------------------------------------------------------------------------------------------------
setup_jenkins_1       /sbin/tini -- /usr/local/b ...   Up      0.0.0.0:50000->50000/tcp, 0.0.0.0:8080->8080/tcp
setup_swarm_agent_1   /bin/sh -c java -jar swarm ...   Up
```
