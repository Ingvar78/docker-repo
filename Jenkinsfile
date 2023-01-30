pipeline {
  agent {
    docker {
      image 'nginx:stable'
    }

  }
  stages {
   stage('Clone repository') {
      agent any
      when {
        branch 'main'
      }
      steps {
	  /* Let's make sure we have the repository cloned to our workspace */
	  checkout scm
      }
    }
    stage('Build&Push images') {
      agent any
      when {
        branch 'main'
      }
     steps {
	  /* Let's make sure we have the repository cloned to our workspace */
	  checkout scm
      }
      steps {
        sh '"docker version"'
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
        withKubeConfig(credentialsId: 'kubernetes-creds', serverUrl: "${CLUSTER_URL}", namespace: "${CLUSTER_NAMESPACE}") {
          sh "helm upgrade ${HELM_PROJECT} ${HELM_CHART} --reuse-values --set backend.image.tag=${env.IMAGE_TAG}"
        }

      }
    }

  }
  environment {
    IMAGE_BASE = 'egerpro/nginx-app'
    IMAGE_TAG = "v$BUILD_NUMBER"
    IMAGE_NAME = "${env.IMAGE_BASE}:${env.IMAGE_TAG}"
    IMAGE_NAME_LATEST = "${env.IMAGE_BASE}:latest"
    DOCKERFILE_NAME = 'Dockerfile-pack'
  }
  options {
    skipStagesAfterUnstable()
    skipDefaultCheckout()
  }
}
