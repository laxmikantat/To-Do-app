pipeline {
    agent { label 'docker' } // Run on your Docker-enabled agent
    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials'
        IMAGE_NAME = 'laxmikant1109/my-to-do'
        IMAGE_TAG = '1.0'
    }
    options {
        skipDefaultCheckout() // We'll do a clean checkout manually
    }
    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir() // Clean Jenkins workspace completely
            }
        }

        stage('Checkout Code') {
            steps {
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/main']],
                          doGenerateSubmoduleConfigurations: false,
                          extensions: [[$class: 'CleanCheckout']], // ensures clean checkout
                          userRemoteConfigs: [[url: 'https://github.com/laxmikantat/To-Do-app.git']]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build docker image from current workspace
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}", ".")
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKERHUB_CREDENTIALS}",
                    usernameVariable: 'DOCKER_HUB_USER',
                    passwordVariable: 'DOCKER_HUB_PASS')]) 
                {
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
            // Logout from Docker Hub to avoid credentials issues
            sh "docker logout || true"
        }
        success {
            echo "Docker image built & pushed successfully!"
        }
        failure {
            echo "Build failed. Check logs."
        }
    }
}
