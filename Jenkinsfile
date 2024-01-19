pipeline {
    agent any
    environment {
        THE_BUTLER_SAYS_SO=credentials('Jenkins')
    }
    stages {
        stage('clean workspace') {
            steps{
                cleanWs()
            }
        }
        stage('Checkout from Git') {
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
                sh "docker image push bangarujyothiswar/devsecops:$BUILD_ID"
            }
        }
        stage('Ensure kubernetes cluster is up') {
            steps {
                sh 'cd deployment/terraform/aws && terraform init && terraform fmt && terraform validate && terraform plan -var-file values.tfvars && terraform apply -var-file values.tfvars --auto-approve'
            }
        }
        stage('deploy the netflix code') {
            steps {
                sh 'aws eks update-kubeconfig --name my-eks-cluster'
                sh "kubectl apply -f deployment/k8s/deployment.yaml"
                sh """
                kubectl patch deployment netflix-app -p '{"spec":{"template":{"spec":{"containers":[{"name":"netflix-app","image":"bangarujyothiswar/devsecops:$BUILD_ID""}]}}}}'
                """
            }
        }
    }
}  
