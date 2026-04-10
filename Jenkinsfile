pipeline {
    agent any

    environment {
        IMAGE_NAME = "devops-capstone"
        DOCKERHUB_USERNAME = "pranavpatildevops"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Pranavpatil09/devops-capstone-project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $DOCKERHUB_USERNAME/$IMAGE_NAME:latest .
                '''
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    '''
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                sh '''
                docker push $DOCKERHUB_USERNAME/$IMAGE_NAME:latest
                '''
            }
        }

        stage('Deploy to EC2') {
            steps {
                sh '''
                docker pull $DOCKERHUB_USERNAME/$IMAGE_NAME:latest
                docker stop capstone || true
                docker rm capstone || true
                docker run -d --name capstone -p 80:5000 $DOCKERHUB_USERNAME/$IMAGE_NAME:latest
                '''
            }
        }
    }

    post {
        success {
            echo "🚀 Deployment Successful"
        }
        failure {
            echo "❌ Pipeline Failed"
        }
    }
}
