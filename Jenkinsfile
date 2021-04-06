pipeline {
  agent any
  stages {
    stage('Parallel execution') {
      parallel {
        stage('Hello world') {
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
            sh 'ci/build-app.sh'
          }
        }

      }
    }

    stage('Archive') {
      steps {
        archiveArtifacts 'app/build/libs/'
      }
    }

  }
}