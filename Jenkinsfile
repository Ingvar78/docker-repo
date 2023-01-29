pipeline {
  agent {
    docker {
      image 'nginx:stable'
    }

  }
  stages {
    stage('Push images') {
      agent any
      when {
        branch 'main'
      }
      steps {
        script {
          echo "Pushed Docker Image: ${env.IMAGE_NAME}"
        }

        sh "docker images"
        sh 'docker images'
      }
    }

  }
  environment {
    IMAGE_BASE = 'egerpro/nginx-app'
    IMAGE_TAG = 'v$BUILD_NUMBER'
    IMAGE_NAME = '${env.IMAGE_BASE}:${env.IMAGE_TAG}'
    IMAGE_NAME_LATEST = '${env.IMAGE_BASE}:latest'
    DOCKERFILE_NAME = 'Dockerfile'
  }
  options {
    skipDefaultCheckout()
  }
}