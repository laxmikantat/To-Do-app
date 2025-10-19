pipeline {
    agent { label 'docker' }   // or 'any' if Docker runs on master
    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials'
        IMAGE_NAME = 'laxmikant1109/my-to-do'
        IMAGE_TAG = '1.0'
    }
    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/laxmikantat/To-Do-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}",
                                                  passwordVariable: 'DOCKER_HUB_PASS',
                                                  usernameVariable: 'DOCKER_HUB_USER')]) {
                    sh "echo $DOCKER_HUB_PASS | docker login -u $DOCKER_HUB_USER --password-stdin"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
    }
    post {
        always {
            sh "docker logout || true"
        }
    }
}
