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

        stage('error') {
          steps {
            sh 'echo "i\'m to"'
          }
        }

      }
    }

    stage('tep 3 pablish app') {
      steps {
        sh 'echo "Run 3"'
      }
    }

  }
}