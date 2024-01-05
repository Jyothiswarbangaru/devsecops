pipeline {
    agent none 
    stages {
        stage('clean workspace'){
            agent { label 'docker' }
            steps{
                cleanWs()
            }
        }
        stage('Checkout from Git'){
            agent { label 'docker' }
            steps{
                git branch: 'main', url: 'https://github.com/Jyothiswarbangaru/devsecops.git'
            }
        }
        stage('Build docker image') {
            agent { label 'docker' }
            steps {
                sh "docker image build -t bangarjyothiswar/foralpine:$BUILD_ID ."
            }
        }
        stage('Trivy Scan') {
            agent { label 'docker' }
            steps {
                script {
                    sh "trivy image --format json -o trivy-report.json bangarjyothiswar/foralpine:$BUILD_ID"
                }
                publishHTML([reportName: 'Trivy Vulnerability Report', reportDir: '.', reportFiles: 'trivy-report.json', keepAll: true, alwaysLinkToLastBuild: true, allowMissing: false])
            }
        }
        stage('publish docker image') {
            agent { label 'docker' }
            steps {
                sh "docker image tag foralpine:$BUILD_ID bangarjyothiswar/foralpine:$BUILD_ID"
                sh "docker image push bangarujyothiswar/foralpine:$BUILD_ID"
            }
        }
    } 
    stages {
        agent { label 'k8s' }
        stage('k8s cluster') {
        sh "terraform fmt && terraform init && terraform apply -auto-approve"
        }
        stage('kubescape') {
                
        }
    }
}