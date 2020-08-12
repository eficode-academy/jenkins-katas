pipeline {
  agent any

  environment {
    docker_username = 'mifor16'
  }

  stages {
    stage('Clone Down') {
      steps {
        sh 'echo "yellow ornage"'
        stash(excludes: '.git/*', name: 'code')
      }
    }

    stage('Parallel Execution') {
      parallel {
        stage('Say Hello') {
          steps {
            sh 'echo "hello world"'
          }
        }

        stage('build app') {
          agent {
            docker {
              image 'gradle:jdk11'
            }

          }
          options {
            skipDefaultCheckout(true)
          }
          steps {
            unstash 'code'
            sh 'ci/build-app.sh'
            archiveArtifacts 'app/build/libs/'
          }
        }

        stage('test app') {
          agent {
            docker {
              image 'gradle:jdk11'
            }

          }
          options {
            skipDefaultCheckout(true)
          }
          steps {
            unstash 'code'
            sh 'ci/unit-test-app.sh'
            junit 'app/build/test-results/test/TEST-.xml'
          }
        }

      }
    }

    stage('push docker app') {
          agent {
            docker {
              image 'gradle:jdk11'
            }

          }
          options {
            skipDefaultCheckout(true)
          }
          environment {
            DOCKERCREDS = credentials('docker_login') //use the credentials just created in this stage
          }
          steps {
            unstash 'code' //unstash the repository code
            sh 'ci/build-docker.sh'
            sh 'echo "$DOCKERCREDS_PSW" | docker login -u "$DOCKERCREDS_USR" --password-stdin' //login to docker hub with the credentials above
            sh 'ci/push-docker.sh'
          }
        }

  }
  
}