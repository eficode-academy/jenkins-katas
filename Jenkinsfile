pipeline {
  agent any
  environment { 
    docker_username = 'jerere'
  }
  stages {
    stage('clone down') {
      agent {label 'master-label'}
      steps {
        stash excludes: '.git', name: 'code'
      }
    }
    stage('Parallel execution') {
      parallel {
        stage('Say Hello') {
          options {
            skipDefaultCheckout(true)
          }
          steps {
            sh 'echo "hello world"'
          }
        }

        stage('build app') {
          options {
            skipDefaultCheckout(true)
          }
          agent {
            docker {
              image 'gradle:jdk11'
            }
          }
          steps {
            sh 'ci/build-app.sh'
            archiveArtifacts 'app/build/libs/'
            deleteDir()
            sh 'ls'
          }
        }

        stage('test app') {
          options {
            skipDefaultCheckout(true)
          }
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

    stage('build and push docker') {
      options {
        skipDefaultCheckout(true)
      }
      environment {
        DOCKERCREDS = credentials('docker_login')
      }
      steps {
        unstash 'code'
        pushIfMaster()
      }
    }
  }
}

void pushIfMaster() {
    if (BRANCH_NAME=="master"){
      sh 'echo "$DOCKERCREDS_PSW" | docker login -u "$DOCKERCREDS_USR" --password-stdin'
      sh 'ci/push-docker.sh'
    }
}