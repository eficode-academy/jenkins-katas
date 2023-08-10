pipeline {
  agent any
  stages {
    stage('Say Hello') {
      parallel {
        stage('Say Hello') {
          steps {
            sh 'echo "hello world"'
          }
        }

        stage('Say Gihri') {
          steps {
            sh 'echo "Gihri"'
          }
        }

      }
    }

  }
}