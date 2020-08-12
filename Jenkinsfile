pipeline {
  agent any
  stages {
      stage('Clone Down') {
        options {
            skipDefaultCheckout(true)
        }
        steps {
          // node (
          //   label: 'host'
          // )
          stash (
            excludes: '.git',
            name: 'code'
          )
            
        }
      } 
      stage('Parallel execution') {
        parallel {
          stage('Say Hello') {
            steps {
              sh 'echo "hello world"'
            }
          }
          stage('Build App') {
            agent {
              docker {
                image 'gradle:jdk11'
              }
            }
            steps {
              sh 'ci/build-app.sh'
              sh 'ls'
              deleteDir()
              sh 'ls'
            }
          }
        }
      }
      stage('Test App'){
        steps {
          unstash '.git'
          sh label: '', script: ' \'ci/unit-test-app.sh\''
          junit 'app/build/test-results/test/TEST-*.xml'
        }
        post {
          always {
              deleteDir() /* clean up our workspace */
          }
        }
      }
      stage('push docker app'){
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