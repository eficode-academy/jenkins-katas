pipeline {
  agent any
  stages {
    stage('Parallel Execution') {
      parallel {
        stage('Say Hello') {
          steps {
            sh 'echo "Hello World"'
          }
        }

        stage('build app') {
          agent {
            docker {
              image 'gradle:jdk11'
            }

          }
          steps {
            sh 'ci/build-app.sh'
            archiveArtifacts 'app/build/libs/'
          }
        }

      }
    }

  }
}