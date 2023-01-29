pipeline {
  agent none
  options {
    skipDefaultCheckout()
  }
  environment {
    IMAGE_BASE = 'egerpro/nginx-app'
    IMAGE_TAG = "v1.0.$BUILD_NUMBER"
    IMAGE_NAME = "${env.IMAGE_BASE}:${env.IMAGE_TAG}"
    IMAGE_NAME_LATEST = "${env.IMAGE_BASE}:latest"
    DOCKERFILE_NAME = "Dockerfile-pack"
  }
  stages {
    stage("Prepare container") {
      agent {
        docker {
          image 'nginx:stable'
        }
      }
    }

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
      }
    }

    stage('Trigger kubernetes') {
      agent any
      when {
        branch 'main'
      }
      steps {
        withKubeConfig([credentialsId: 'kubernetes-creds', serverUrl: "${CLUSTER_URL}", namespace: "${CLUSTER_NAMESPACE}"]) {
          sh "helm upgrade ${HELM_PROJECT} ${HELM_CHART} --reuse-values --set backend.image.tag=${env.IMAGE_TAG}"
        }
      }
    }
  }
}