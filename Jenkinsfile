pipeline {
  agent any
  stages {
    stage("Clone down") {
      agent { label "host" }
      steps {
        stash excludes: '.git', name: 'code'
      }
    }
    stage('Parallel execution') {
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
            skipDefaultCheckout true
          }
          steps {
            unstash 'code'
            sh 'ci/build-app.sh'
            archiveArtifacts 'app/build/libs/'
          }
          post {
              cleanup {
                  sh "ls -l"
                  deleteDir()
                  sh "ls -l"
              }
          }
        }

      }
    }

  }
}