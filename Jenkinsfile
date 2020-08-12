pipeline {
  agent any
  environment {
    docker_username = 'benz56'
  }
  stages {
    stage('Clone down'){
      steps{
        stash excludes: '.git', name: 'code'
      }
    }
    stage('Say Hello') {
      parallel {
        stage('Parallel execution') {
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
            stash 'build'
            archiveArtifacts 'app/build/libs/'
            sh 'ls'
            deleteDir()
            sh 'ls'
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
    }

    stage('push docker app') {
      when { branch "master" }
      options {
        skipDefaultCheckout()
      }
      environment {
        DOCKERCREDS = credentials('docker_login') //use the credentials just created in this stage
      }
      steps {
        unstash 'build' //unstash the repository code
        sh 'ci/build-docker.sh'
        sh 'echo "$DOCKERCREDS_PSW" | docker login -u "$DOCKERCREDS_USR" --password-stdin' //login to docker hub with the credentials above
        sh 'ci/push-docker.sh'
      }
    }

    stage('Component test') {
      when { 
        not {
          branch 'dev/*'
        }
      }
      options {
        skipDefaultCheckout()
      }
      steps {
        sh 'ci/component-test.sh'
      }
    }
  }

  post {
    always {
       deleteDir() /* clean up our workspace */
    }
  }
}