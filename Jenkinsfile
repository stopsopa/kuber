pipeline {

    agent any

    stages {
        stage('Step 1') {
            steps{
                sh "echo 'test 1...'"
                // sh "docker rmi $registry:latest"
            }
        }
        stage('Step 2') {
            steps{
                bash "echo 'test 2...'"
                // sh "docker rmi $registry:latest"
            }
        }

    }
}
