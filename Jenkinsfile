pipeline {
  agent any
    environment {
    docker_username='praqmasofus'
  }
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
            stash 'code'
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
    stage('docker build and push') {
          options {
            skipDefaultCheckout()
          }
          environment {
              DOCKERCREDS = credentials('docker_login') //use the credentials just created in this stage
          }
          steps {
            unstash 'code'
            sh 'ci/build-docker.sh'
            sh 'echo "$DOCKERCREDS_PSW" | docker login -u "$DOCKERCREDS_USR" --password-stdin' //login to docker hub with the credentials above
            //input message: 'push?', ok: 'Yes'
            sh 'ci/push-docker.sh'
          }
        }


  }         
  post {
            always {
              deleteDir()
            }

          }
 
}