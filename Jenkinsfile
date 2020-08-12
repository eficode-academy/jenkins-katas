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
            unstash 'code'
            sh 'ci/build-app.sh'
            archiveArtifacts 'app/build/libs/'
            stash(name: 'pushcode', excludes: '.git')
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
            junit 'app/build/test-results/test/TEST-*.xml'
          }
        }

      }
    }

    stage('push docker app') {
      when {
        branch 'master'
      }
      environment {
        DOCKERCREDS = credentials('docker_login')
      }
      steps {
        unstash 'pushcode'
        sh 'ci/build-docker.sh'
        sh 'echo "$DOCKERCREDS_PSW" | docker login -u "$DOCKERCREDS_USR" --password-stdin'
        sh 'ci/push-docker.sh'
      }
    }

    stage('Component Test') {
      when {
        beforeAgent true
        not {
          branch 'dev/'
        }

      }
      steps {
        sh 'ci/component-test.sh'
      }
    }

  }
  environment {
    docker_username = 'prikx'
  }
}