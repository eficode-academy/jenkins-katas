pipeline {
  agent any
  stages {
    stage('clone down') {
      agent any
      steps {
        stash(name: 'code', excludes: '.git')
      }
    }

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
            unstash 'code'
          }
        }

        stage('Test app') {
          steps {
            unstash 'code'
            sh 'ci/unit-test-app.sh'
            sh 'junit \'app/build/test-result/test/TEST-*.xml\''
          }
        }

      }
    }

  }
}