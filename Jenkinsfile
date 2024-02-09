pipeline {
    agent none
    environment{
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_credentials')
        AWS_DEFAULT_REGION ='us-east-1'
        THE_BUTLER_SAYS_SO =credentials('waytoUserGroup')
    }
    stages {
        stage('clean workspace') {
            agent{label 'docker'}
            steps{
                cleanWs()
            }
        }
        stage('Checkout from Git') {
            agent {label 'docker'}
            steps{
                git branch: 'main', url: 'https://github.com/Jyothiswarbangaru/devsecops.git'
            }
        }
        stage('Build docker image') {
            agent {label 'docker'}
            steps {
                sh "docker image build -t bangarujyothiswar/devsecops:$BUILD_ID ."
            }
        }
        stage('Trivy Scan') {
            agent {label 'docker'}
            steps {
                script {
                    sh "trivy image --format json -o trivy-report.json bangarujyothiswar/devsecops:$BUILD_ID"
                }
                publishHTML([reportName: 'Trivy Vulnerability Report', reportDir: '.', reportFiles: 'trivy-report.json', keepAll: true, alwaysLinkToLastBuild: true, allowMissing: false])
            }
        }
        stage('publish docker image') {
            agent {label 'docker'}
            steps {
                sh "docker login -u bangarujyothiswar -p Eswar@123 docker.io"
                sh "docker image push bangarujyothiswar/devsecops:$BUILD_ID"
            }
        }
        stage('Ensure kubernetes cluster is up') {
            agent {label 'kubernetes'}
            steps {
                sh 'cd deployment/terraform/aws && terraform init -reconfigure && terraform fmt && terraform validate && terraform plan -var-file values.tfvars && terraform apply -var-file values.tfvars --auto-approve'
            }
        }
        stage('deploy the netflix code') {
            agent {label 'kubernetes'}
            steps {
                sh "aws eks update-kubeconfig --name my-eks-cluster"
                sh "kubectl apply -f deployment/k8s/deployment.yaml --validate=false"
                sh """
                kubectl patch deployment netflix-app -p '{"spec":{"template":{"spec":{"containers":[{"name":"netflix-app","image":"bangarujyothiswar/devsecops:$BUILD_ID"}]}}}}'
                """
            }
        }
        stage('kubescape scan'){
            agent {label 'kubernetes'}
            steps{
                script {
                    sh "/usr/bin/kubescape scan -t 40 deployment/k8s/deployment.yaml --format junit -o TEST-report.xml"
                    junit "**/TEST-*.xml"
                }
            }
        }
    }
}