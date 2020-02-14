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
                bash "/bin/bash jenkins/step2.sh"
                // sh "docker rmi $registry:latest"
            }
        }
        stage('Step 3') {
            steps{
                bash "/bin/bash jenkins/step3.sh"
                // sh "docker rmi $registry:latest"
            }
        }

    }
}
