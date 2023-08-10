pipeline {
  tools {
        docker 'docker' 
  }
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
            sh cd ci/
            sh ./build-app.sh
          }
        }

      }
    }

  }
}
