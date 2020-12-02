pipeline {
  agent any
  environment {
    docker_username = credentials('docker_username')
  }

  stages {
    stage('Master branch build') {
      when { branch "master" }
      steps {
        sh 'echo "On master branch, push test"'
      }
    }

    stage('Dev branch build') {
      when { branch "dev" }
      steps {
        sh 'echo "On dev branch"'
      }
    }

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
          when {
            beforeAgent true
            branch 'master'
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
          post {
            always {
              deleteDir()
            }

          }
          steps {
            skipDefaultCheckout true
            unstash 'code'
            sh 'ci/unit-test-app.sh'
            junit 'app/build/test-results/test/TEST-*.xml'
          }
        }

      }
    }

    stage('push docker app') {
      environment {
        DOCKERCREDS = credentials('docker_login') //use the credentials just created in this stage
      }
      steps {
        unstash 'code' //unstash the repository code
        sh 'ci/build-docker.sh'
        //input message: 'Approve push to Dockerhub?', ok: 'Yes'
        //sh 'echo "$DOCKERCREDS_PSW" | docker login -u "$DOCKERCREDS_USR" --password-stdin' //login to docker hub with the credentials above
        //sh 'ci/push-docker.sh'
      }
    }
  }
}
