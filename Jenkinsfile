pipeline {
  agent {
    node {
      label 'centos'
    }

  }
  stages {
    stage('Get Credentional') {
      steps {
        echo ' ------------------- Get Credentials --------------------'
        sh '''if [ ! -s /var/jenkins/credentialImported ]; then
   curl http://10.0.10.5:8080/jnlpJars/jenkins-cli.jar -o jenkins-cli.jar
   java -jar jenkins-cli.jar -s http://10.0.10.5:8080 import-credentials-as-xml "system::system::jenkins" < /var/jenkins/credentials.xml
   echo \'imported\' > /var/jenkins/credentialImported
fi
            '''
      }
    }

  }
}