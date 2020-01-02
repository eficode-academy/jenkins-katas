pipeline {
  agent any
  stages {
    stage('say hello') {
      parallel {
        stage('say hello') {
          steps {
            sh '''echo "hello world"
'''
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