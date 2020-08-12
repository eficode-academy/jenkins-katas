pipeline {
  agent any
  stages {

    stage('Clone Down') {
      steps {
        node {
          label 'host'
        }
        stash {
          exclude '.git'
        }
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
          skipDefaultCheckout(true)
        }
      }
    }
  }
}