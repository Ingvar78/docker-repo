pipeline {
  agent {
    node {
      label 'centos'
    }

  }
  stages {
    stage('Get Credentional') {
      steps {
            echo " ------------------- Get Credentials --------------------"
            sh """
            if [ ! -s /var/jenkins/credentialImported ]; then
                curl http://localhost:8080/jnlpJars/jenkins-cli.jar -o jenkins-cli.jar
                java -jar jenkins-cli.jar -s http://localhost:8080 import-credentials-as-xml "system::system::jenkins" < /var/jenkins/exported-credentials.xml
                echo 'imported' > /var/jenkins/credentialImported
            fi
            """
      }
    }

  }
}