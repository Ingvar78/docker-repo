pipeline {
  agent any
  stages {
    stage('Push images') {
      agent any
      when {
        branch 'main'
      }
      steps {
        script {
          def dockerImage = docker.build("${env.IMAGE_NAME}", "-f ${env.DOCKERFILE_NAME} .")
          echo "Pushed Docker Image: ${env.IMAGE_NAME}"
        }

        sh "docker rmi ${env.IMAGE_NAME} ${env.IMAGE_NAME_LATEST}"
      }
    }

    stage('Trigger kubernetes') {
      agent any
      when {
        branch 'master'
      }
      steps {
        echo ' ------------------- Kuber --------------------'
      }
    }

  }
  environment {
    IMAGE_BASE = 'egerpro/nginx-app'
    IMAGE_TAG = 'v$BUILD_NUMBER'
    IMAGE_NAME = '${env.IMAGE_BASE}:${env.IMAGE_TAG}'
    IMAGE_NAME_LATEST = '${env.IMAGE_BASE}:latest'
    DOCKERFILE_NAME = 'Dockerfile-packaged'
  }
  options {
    skipDefaultCheckout()
  }
}