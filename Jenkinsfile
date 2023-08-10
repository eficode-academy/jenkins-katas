pipeline {
  agent {
    docker {
      image 'gradle:6-jdk11'
    }

  }
  stages {
    stage('Say Hello') {
      parallel {
        stage('Say Hello') {
          steps {
            sh 'echo "hello world"'
          }
        }

        stage('Build App') {
          agent {
            docker {
              image 'gradle:6-jdk11'
            }

          }
          steps {
            sh './ci/build-app.sh'
          }
        }

      }
    }

  }
}