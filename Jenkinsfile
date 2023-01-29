pipeline {
    agent any
    environment {
	IMAGE_BASE = 'egerpro/nginx-app'
	IMAGE_TAG = 'v$BUILD_NUMBER'
	IMAGE_NAME = '${env.IMAGE_BASE}:${env.IMAGE_TAG}'
	IMAGE_NAME_LATEST = '${env.IMAGE_BASE}:latest'
	DOCKERFILE_NAME = 'Dockerfile-packaged'
    }
    stages {
        stage('Build') {
            agent {
                docker {
                    image '${env.IMAGE_BASE}'
                    // Run the container on the node specified at the
                    // top-level of the Pipeline, in the same workspace,
                    // rather than on a new node entirely:
                    reuseNode true
                }
            }
            steps {
                sh '${env.IMAGE_NAME} --version'
            }
        }
    }
}