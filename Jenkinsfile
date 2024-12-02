pipeline {
    agent none
    stages {
        stage('Prepare Workspace') {
            agent { label 'aws-worker' }
            steps {
                script {
                    sh 'rm -rf step-project-2'
                }
            }
        }
        stage('Pull the Code') {
            agent { label 'aws-worker' } 
            steps {
                git branch: 'main', url: 'https://github.com/Kseniia-FS/step-project-2.git'
            }
        }
        stage('Build the Docker Image') {
            agent { label 'aws-worker' }
            steps {
                script {
                    sh 'docker build -t kseniiafs/project2 .'
                }
            }
        }
        stage('Run Tests') {
            agent { label 'aws-worker' }
            steps {
                script {
                    try {
                        sh 'docker run --rm kseniiafs/project2 npm test'
                    } catch (Exception e) {
                        error "Tests failed" 
                    }
                }
            }
        }
        stage('Push to Docker Hub') {
            agent { label 'aws-worker' }
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        sh '''
                            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                            docker push kseniiafs/project2
                        '''
                    }
                }
            }
        }
    }
    post {
        failure {
            echo "Tests failed. Pipeline terminated."
        }
        success {
            echo "Pipeline completed successfully."
        }
    }
}
