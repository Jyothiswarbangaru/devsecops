pipeline {
    agent any
    stages {
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        stage('Checkout from Git'){
            steps{
                git branch: 'main', url: 'https://github.com/Jyothiswarbangaru/devsecops.git'
            }
        }
        stage('Build docker image') {
            steps {
                sh "docker image build -t bangarujyothiswar/devsecops:$BUILD_ID ."
            }
        }
        stage('Trivy Scan') {
            steps {
                script {
                    sh "trivy image --format json -o trivy-report.json bangarujyothiswar/devsecops:$BUILD_ID"
                }
                publishHTML([reportName: 'Trivy Vulnerability Report', reportDir: '.', reportFiles: 'trivy-report.json', keepAll: true, alwaysLinkToLastBuild: true, allowMissing: false])
            }
        }
        stage('publish docker image') {
            steps {
                sh "docker image tag bangarujyothiswar/devsecops:latest bangarujyothiswar/devops:$BUILD_ID"
                sh "docker image push bangarujyothiswar/devops:$BUILD_ID"
            }
        }
    }
}