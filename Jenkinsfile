pipeline {
  agent any
  environment { 
    docker_username = 'zandonknighton'
  }
  stages {
    stage('clone down') {
      agent {
        node {
          label 'master-label'
        }

      }
      steps {
        stash(name: 'code', excludes: '.git')
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
          agent {
            docker {
              image 'gradle:jdk11'
            }

          }
          steps {
            skipDefaultCheckout true
            unstash 'code'
            sh 'ci/build-app.sh'
            stash(name: 'code', excludes: '.git')
            archiveArtifacts 'app/build/libs/'
            sh 'ls -al'
            deleteDir()
            sh 'ls -al'
          }
        }

        stage('test app') {
          agent {
            docker {
              image 'gradle:jdk11'
            }

          }
          steps {
            skipDefaultCheckout true
            unstash 'code'
            sh 'ci/unit-test-app.sh'
            junit 'app/build/test-results/test/TEST-*.xml'
          }
          post {
            always {
              deleteDir() /* clean up our workspace */
            }
          }
        }
      }
    }

  }
}
