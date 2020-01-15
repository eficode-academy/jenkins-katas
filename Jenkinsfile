pipeline {
  agent any
    triggers {
  pollSCM 'H/2 * * * *'
}
  environment { 
        docker_username = 'praqmasofus'
  }
  stages {
    stage('clone down') {
      steps {
        stash(excludes: '.git', name: 'code')
        deleteDir()
      }
    }

    stage('Test and build') {
      parallel {
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
            stash(excludes: '.git', name: 'code')
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
            unstash 'code'
            sh 'ci/build-app.sh'
            archiveArtifacts 'app/build/libs/'
            stash(excludes: '.git', name: 'code')
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
        echo '$CHANGE_TARGET tries to integrate into $CHANGE_BRANCH'
        unstash 'code'
        sh 'ci/build-docker.sh'
        pushifmaster() // This is a script inside a declarative pipeline
      }
    }
    stage('component test') {
      when { not {changeRequest() } }
      options {
        skipDefaultCheckout(true)
      }
      steps {
        unstash 'code'
        sh 'ci/component-test.sh'
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