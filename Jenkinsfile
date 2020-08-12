pipeline {
  agent any
  stages {
    stage('Say Hello') {
      parallel {
        stage('Parallel execution') {
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
          environment {
            skipDefaultCheckout = 'true'
          }
          steps {
            sh 'ci/build-app.sh'
            archiveArtifacts 'app/build/libs/'
            sh 'ls'
            deleteDir()
            sh 'ls'
          }
        }

        stage('') {
          agent {
            node {
              label 'host'
            }

          }
          steps {
            stash(name: 'code', excludes: '.git')
          }
        }

      }
    }

  }
}