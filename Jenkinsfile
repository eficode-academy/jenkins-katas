pipeline {
  agent any

  environment {
    docker_username = "pleksi"
  }

  stages {
    stage("Clone down") {
      agent { label "master-label" }
      steps {
        stash excludes: '.git', name: 'code'
      }
    }
    stage('Parallel execution') {
      parallel {
        stage('Say Hello') {
          steps {
            sh 'echo "hello world"'
          }
        }

        stage('Build app') {
          agent {
            docker {
              image 'gradle:jdk11'
            }
          }
          options {
            skipDefaultCheckout true
          }
          steps {
            unstash 'code'
            sh 'ci/build-app.sh'
            stash excludes: '.git', name: 'code'
            archiveArtifacts 'app/build/libs/'
          }
          post {
              cleanup {
                  sh "ls -l"
                  deleteDir()
                  sh "ls -l"
              }
          }
        }

        stage("Test app") {
          agent {
            docker {
              image 'gradle:jdk11'
            }
          }
          options {
            skipDefaultCheckout true
          }
          steps {
            unstash "code"
            sh "ci/unit-test-app.sh"
            junit 'app/build/test-results/test/TEST-*.xml'
          }
        }
      }
    }
    stage("Push Docker app") {
      environment {
        DOCKER_CREDENTIALS = credentials("docker_cred")
      }
      steps {
            unstash 'code' //unstash the repository code
            input message: 'Push to docker?', ok: 'Yes'
            sh 'ci/build-docker.sh'
            sh 'echo "$DOCKER_CREDENTIALS_PSW" | docker login -u "$DOCKER_CREDENTIALS_USR" --password-stdin' //login to docker hub with the credentials above
            sh 'ci/push-docker.sh'
      }
    }

  }
}