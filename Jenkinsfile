
pipeline {
  environment {
    docker_username = 'emilkolvigraun'
  }
  agent any
  stages {
      stage('Clone Down') {
        options {
            skipDefaultCheckout(true)
        }
        steps {
          // node (
          //   label: 'host'
          // )
          stash (
            excludes: '.git',
            name: 'code'
          )
            
        }
      } 
      stage('Parallel execution') {
        parallel {
          stage('Say Hello') {
            steps {
              sh 'echo "hello world"'
            }
          }
          stage('Build App') {
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
              sh 'ci/build-app.sh'
              stash 'code'
              sh 'ls'
              deleteDir()
              sh 'ls'
            }
          }
          stage('Test App'){
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
            post {
              always {
                  deleteDir() /* clean up our workspace */
              }
            }
          }
        }
      }
        stage('push docker app'){
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
        stage('Component Test') {
          when { 
            not {
              branch "dev/*" 
              }
            }
          steps {
            sh 'ci/component-test.sh'
            sh 'echo done'
          }
        }
      }
      
  }