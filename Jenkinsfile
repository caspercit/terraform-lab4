pipeline {
  agent any
  stages {
    stage('Terraform fmt') {
      steps { dir('infra') { sh 'terraform fmt -check -recursive' } }
    }
    stage('Terraform init') {
      steps { dir('infra') { sh 'terraform init -backend=false -input=false' } }
    }
    stage('Terraform validate') {
      steps { dir('infra') { sh 'terraform validate -no-color' } }
    }
  }
}
// Validacion solamente: no hace apply ni almacena credenciales.
