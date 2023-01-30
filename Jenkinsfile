pipeline {
  agent none
  stages {
    stage('Build&Push images') {
      agent any
      when {
        branch 'main'
      }
      steps {
        echo "Prepare Docker Image: ${env.IMAGE_NAME}, DockerFile: ${env.DOCKERFILE_NAME}"
        checkout(scm: scm, changelog: true, poll: true)
        sh "echo ${env.IMAGE_NAME} ${env.IMAGE_NAME_LATEST} >./site/version.txt"
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
        checkout(scm: scm, changelog: true, poll: true)
        withKubeConfig(credentialsId: 'kubernetes-creds', serverUrl: "${CLUSTER_URL}", namespace: "${CLUSTER_NAMESPACE}") {
          sh "helm upgrade ${HELM_PROJECT} ${HELM_CHART} --reuse-values --set image.tag=${env.IMAGE_TAG} --debug"
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
    HELM_PROJECT = 'my-app'
    HELM_CHART = './neto-app/'
  }
  options {
    skipStagesAfterUnstable()
    skipDefaultCheckout()
  }
}
