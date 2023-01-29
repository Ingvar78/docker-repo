pipeline {
  agent {
    node {
      label 'centos'
    }

  }
  stages {
    stage('error') {
      steps {
        sh '''println "uname -a".execute().text

println System.getenv("PATH")'''
      }
    }

  }
}