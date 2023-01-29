pipeline {
  agent {
    node {
      label 'cebtos'
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