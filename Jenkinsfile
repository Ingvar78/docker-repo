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
          def dockerImage = docker.build("${env.IMAGE_NAME}", "-f ${env.DOCKERFILE_NAME} .")
          docker.withRegistry('', 'dockerhub-creds') {
            dockerImage.push()
            dockerImage.push("latest")
          }
          echo "Pushed Docker Image: ${env.IMAGE_NAME}"
        }

        sh "docker rmi ${env.IMAGE_NAME} ${env.IMAGE_NAME_LATEST}"
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