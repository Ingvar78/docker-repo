pipeline {
  agent {
    node {
      label 'centos'
    }

  }
  environment {
    IMAGE_BASE = 'egerpro/nginx-app'
    IMAGE_TAG = 'v$BUILD_NUMBER'
    IMAGE_NAME = '${env.IMAGE_BASE}:${env.IMAGE_TAG}'
    IMAGE_NAME_LATEST = '${env.IMAGE_BASE}:latest'
    DOCKERFILE_NAME = 'Dockerfile-packaged'
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