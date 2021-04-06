pipeline {
  agent any
  stages {
    stage('Clone down') {
      steps {
        stash(excludes: '.git', name: 'code')
      }
    }

    stage('Parallel execution') {
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
          options {
            skipDefaultCheckout()
          }
          steps {
            unstash 'code'
            sh 'ci/build-app.sh'
            archiveArtifacts 'app/build/libs/'
          }
        }

        stage('test app') {
          agent {
            docker {
              image 'gradle:jdk11'
            }

          }
          options {
            skipDefaultCheckout()
          }
          steps {
            unstash 'code'
            sh 'ci/unit-test-app.sh'
            junit 'app/build/test-results/test/TEST-*.xml'
          }
        }

    }

        stage('docker thingy') {
          options {
            skipDefaultCheckout()
          }
          environment {
                DOCKERCREDS = credentials('docker_login') //use the credentials just created in this stage
          }
          steps {
                unstash 'code' //unstash the repository code
                sh 'ci/build-docker.sh'
                sh 'echo "$DOCKERCREDS_PSW" | docker login -u "$DOCKERCREDS_USR" --password-stdin' //login to docker hub with the credentials above
                sh 'ci/push-docker.sh'
          }
        }

      }


  }
  post {
    cleanup {
        deleteDir() /* clean up our workspace */
    }
  }
}
