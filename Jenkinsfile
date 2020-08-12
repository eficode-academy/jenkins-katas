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
          agent {
            docker {
              image 'gradle:jdk11'
            }

          }
          steps {
            unstash 'code'
            sh 'ci/unit-test-app.sh'
            sh 'junit \'app/build/test-result/test/TEST-*.xml\''
          }
        }

      }
    }

    stage('push docker app') {
      environment {
        DOCKERCREDS = credentials('docker_login')
      }
      steps {
        sh 'ci/build-docker-sh'
        sh 'echo "$DOCKERCREDS_PSW" | docker login -u "$DOCKERCREDS_USR" --password-stdin'
      }
    }

  }
}