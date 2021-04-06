pipeline {
  agent any
  stages {
    stage('clone down') {
      steps {
        stash(excludes: '.git', name 'code')
      }
    }
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
          options {
            skipDefaultCheckout()
          }
          steps {
            sh 'ci/build-app.sh'
            archiveArtifacts ' app/build/libs/'
          }
        }

      }
      post {
      cleanup {
          deleteDir() /* clean up our workspace */
        }
      }
    }

  }
}
