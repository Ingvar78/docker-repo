pipeline {
  agent {
    node {
      label 'centos'
    }

  }
  stages {
    stage('Get Credentional') {
      parallel {
        stage('Get Credentional') {
          steps {
            echo ' ------------------- Get Credentials --------------------'
            sh '''echo "I\'m running"
            '''
          }
        }

        stage('') {
          steps {
            sh 'echo "i\'m to"'
          }
        }

      }
    }

  }
}