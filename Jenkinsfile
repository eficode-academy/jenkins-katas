pipeline {
  agent any
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
  }
  post {
    always {
      deleteDir() /* clean up our workspace */
    }
  }
}
