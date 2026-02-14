pipeline {
   agent any
   environment {
       IMAGE_NAME = "devops-capstone"
       DOCKERHUB_USERNAME = "pranavpatildevops"
   }
   stages {
       stage('Checkout Code') {
           steps {
               git 'https://github.com/Pranavpatil09/devops-capstone-project.git'
           }
       }
       stage('Build Docker Image') {
           steps {
               sh 'docker build -t $DOCKERHUB_USERNAME/$IMAGE_NAME:latest .'
           }
       }
       stage('Push Image to Docker Hub') {
           steps {
               withCredentials([string(credentialsId: 'dockerhub-password', variable: 'DOCKER_PASS')]) {
                   sh '''
                   echo $DOCKER_PASS | docker login -u $DOCKERHUB_USERNAME --password-stdin
                   docker push $DOCKERHUB_USERNAME/$IMAGE_NAME:latest
                   '''
               }
           }
       }
       stage('Deploy to EC2') {
           steps {
               sh '''
               docker stop capstone || true
               docker rm capstone || true
               docker run -d --name capstone -p 80:5000 $DOCKERHUB_USERNAME/$IMAGE_NAME:latest
               '''
           }
       }
   }
   post {
       success {
           echo "Deployment Successful"
       }
       failure {
           echo "Pipeline Failed"
       }
   }
}
