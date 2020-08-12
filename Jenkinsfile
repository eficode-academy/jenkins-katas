pipeline {
  agent any
  environment {
    docker_username = "nicolaigram"
  }
  stages {
    stage('Clone down') {
      steps {
        stash excludes: '.git/', name: 'allmyfilesyolo'
      }
    }
    stage('Paralel execution') {
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
            skipDefaultCheckout()
          }
          steps {
            unstash 'allmyfilesyolo'
            sh 'ls'
            sh 'ci/build-app.sh'
            archiveArtifacts 'app/build/libs/'
            deleteDir()
            sh 'ls'
            stash 'builtfiles'
          }
        }

        stage('Test app') {
          agent {
            docker {
              image 'gradle:jdk11'
            }
          }
          steps {
            unstash 'allmyfilesyolo'
            sh 'ci/unit-test-app.sh'
            junit 'app/build/test-results/test/TEST-*.xml'
          }
        }
      }
    }
    stage('Push to docker') {
      environment {
        DOCKERCREDS = credentials('docker_login') //use the credentials just created in this stage
      }
      steps {
        unstash 'builtfiles' //unstash the repository code
        sh 'ci/build-docker.sh'
        sh 'echo "$DOCKERCREDS_PSW" | docker login -u "$DOCKERCREDS_USR" --password-stdin' //login to docker hub with the credentials above
        sh 'ci/push-docker.sh'
      }
    }
  }
  post {
    always {
      deleteDir() /* clean up our workspace */
    }
  }
}
