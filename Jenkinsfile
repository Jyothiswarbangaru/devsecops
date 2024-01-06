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
                sh "docker login -u bangarujyothiswar -p Eswar@123 docker.io"
                sh "docker image tag bangarujyothiswar/devsecops:latest bangarujyothiswar/devops:$BUILD_ID"
                sh "docker image push bangarujyothiswar/devops:$BUILD_ID"
            }
        stage('Ensure kubernetes cluster is up') {
            steps {
                sh "cd deployment/terraform && terraform init && terraform apply -auto-approve"
            }
        }
        stage('deploy to k8s') {
            steps {
                sh "kubectl apply -f deployment/k8s/deployment.yaml"
                sh """
                kubectl patch deployment netflix-app -p '{"spec":{"template":{"spec":{"containers":[{"name":"netflix-app","image":"bangarujyothiswar/devops:$BUILD_ID"}]}}}}'
                """
            }
        }
        stage('kubescape Scan') {
            steps {
                script {
                    sh "/home/ubuntu/.kubescape/bin/kubescape scan -t 40 deployment/k8s/deployment.yaml --format junit -o TEST-report.xml"
                    junit "**/TEST-*.xml"}
    }
}
        }
    }
}