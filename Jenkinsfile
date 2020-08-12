pipeline {
  agent any
  environment { 
        docker_username = 'mifor16'
    }
  stages {
    stage('Clone Down'){
        steps{
            stash excludes: '.git', name: 'code'
        }
    }
    stage('Parallel Execution') {
      parallel {
        stage('Say Hello') {
          steps {
            sh 'echo "Hello World"'
          }
        }
        stage('Build App') {
          agent {
            docker {
              image 'gradle:jdk11'
            }
          }
          steps {
            unstash 'code'
            skipDefaultCheckout(true) 
            sh 'ci/build-app.sh'
            archiveArtifacts 'app/build/libs/'
            stash excludes: '.git', name: 'code'
            sh 'ls'
            deleteDir()
            sh 'ls'
          }
        }
        stage('Test App') {
          agent {
            docker {
              image 'gradle:jdk11'
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

    stage('Build Docker app') {
      agent any
      environment {
        DOCKERCREDS = credentials('docker_login') //use the credentials just created in this stage
      }
      steps {
        unstash 'code' //unstash the repository code
        sh 'ci/build-docker.sh'
        stash excludes: '.git', name: 'code'
      }
    }

    stage('Push Docker app'){
      when {
        branch 'master'
      }
      agent any
      environment {
        DOCKERCREDS = credentials('docker_login') //use the credentials just created in this stage
      }
      steps {
        unstash 'code' //unstash the repository code
        sh 'echo "$DOCKERCREDS_PSW" | docker login -u "$DOCKERCREDS_USR" --password-stdin' //login to docker hub with the credentials above
        sh 'ci/push-docker.sh'
        stash excludes: '.git', name: 'code'
      }
    }

    stage('Component Test') {
          agent any
          //when {
          //  not {
          //    branch 'dev/*'
          //  }
          //}
          when { 
            anyOf { 
              branch 'master'; changeRequest() 
              } 
          }
          steps {
            unstash 'code'
            sh 'ci/component-test.sh'
          }
        }
  }
}