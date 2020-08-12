pipeline {
  agent any
    environment {
      docker_username='mathn16'
     }
  stages {
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
            sh 'ci/build-app.sh'
            archiveArtifacts 'app/build/libs/'
            stash 'code'
          }
        }

      }
    }
    stage('docker push app'){
      when {
        branch "master"
      }
        environment {
          DOCKERCREDS = credentials('docker_login')
        }
        steps {
              unstash 'code'
              sh 'ci/build-docker.sh'
              sh 'echo "$DOCKERCREDS_PSW" | docker login -u "$DOCKERCREDS_USR" --password-stdin' //login to docker hub with the credentials above
              sh 'ci/push-docker.sh'
              stash 'binaries'
        }
    }
    stage('component test') {
      when {branch !"dev*"}
      steps {
        unstash 'binaries'
        sh 'ci/component-test.sh'
      }
    }
  }
  post {
      always {
          sh 'ls'
          deleteDir()
          sh 'ls'
      }
  }
}
