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

        stage('Deploy to Auto Scaling Group') {
            steps {
                sh '''
                echo "Triggering AWS Auto Scaling Group Instance Refresh..."
                REFRESH_ID=$(aws autoscaling start-instance-refresh \\
                    --auto-scaling-group-name project-dev-app-asg \\
                    --region ap-south-1 \\
                    --preferences '{"SkipMatching": false, "InstanceWarmup": 0}' \\
                    --query 'InstanceRefreshId' --output text)

                echo "Instance refresh started with ID: $REFRESH_ID"
                echo "Waiting for instance refresh to complete (this may take a few minutes)..."

                while true; do
                    STATUS=$(aws autoscaling describe-instance-refreshes \\
                        --auto-scaling-group-name project-dev-app-asg \\
                        --region ap-south-1 \\
                        --instance-refresh-ids $REFRESH_ID \\
                        --query 'InstanceRefreshes[0].Status' --output text)

                    if [ "$STATUS" = "Successful" ]; then
                        echo "Instance refresh completed successfully!"
                        break
                    elif [ "$STATUS" = "Failed" ] || [ "$STATUS" = "Cancelled" ]; then
                        echo "Instance refresh failed or was cancelled."
                        exit 1
                    else
                        echo "Current status: $STATUS. Waiting 30 seconds..."
                        sleep 30
                    fi
                done
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
