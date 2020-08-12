pipeline {
  agent any
  options {
    skipDefaultCheckout true
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
          steps {
            unstash 'allmyfilesyolo'
            sh 'ci/build-app.sh'
            archiveArtifacts 'app/build/libs/'
            sh 'ls'
            deleteDir()
            sh 'ls'
          }
        }
      }
    }
  }
}
