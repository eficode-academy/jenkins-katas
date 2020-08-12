pipeline {
  agent any
  stages {
    stage('Clone Down') {
      steps {
        sh 'echo "yellow ornage"'
        stash(excludes: '.git/**', name: 'code')
      }
    }

    stage('Parallel Execution') {
      parallel {
        stage('Say Hello') {
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
          steps {
            unstash 'code'
            sh 'ci/build-app.sh'
            archiveArtifacts 'app/build/libs/'
          }
        }

      }
    }

  }
  options {
    skipDefaultCheckout(true)
  }
}