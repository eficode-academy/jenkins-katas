pipeline {
  agent any
  stages {
    stage('clone down'){
      agent {label 'master-label'}
      steps {
        stash excludes: '.git', name: 'code'
      }
    }
    stage('Parallel execution') {
      parallel {
        stage('Say hello') {
          steps {
            sh 'echo "hello world"'
          }
        }

        stage('build app') {
          options { skipDefaultCheckout() }
          agent {
            docker {
              image 'gradle:jdk12'
            }

          }
          steps {
            unstash 'code'
            sh 'ci/build-app.sh'
            archiveArtifacts 'app/build/libs/'
            sh 'ls'
            deleteDir()
          }
        }
        stage('test app') {
          options { skipDefaultCheckout() }
          agent {
            docker {
              image 'gradle:jdk12'
            }

          }
          steps {
            unstash 'code'
            sh 'ci/unit-test-app.sh'
            junit 'app/build/test-results/test/TEST-*.xml'
          }
        }
      }
    }

  }
}