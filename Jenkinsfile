pipeline {
    // environment {
    //     registry = "twlphaseii/node-jenkins-docker"
    //     registryCredential = 'phii-docker-hub'
    // }

    agent any

    stages {
    /*
        stage('Build') {
            agent {
                docker {
                    image 'node:8.12.0-alpine'
                }
            }
            steps {
                sh 'npm install'
            }
        }
        

        stage('Test') {
			agent {
                docker {
                    image 'node:8.12.0-alpine'
                }
            }
            steps {
                sh 'npm test'
            }
        }
        stage('Build and Deploy Image') {
            steps {
                script {
					// here put the custom docker registry intead of ''
					// https://jenkins.io/doc/book/pipeline/docker/#custom-registry
					docker.withRegistry('https://docker-registry.phaseiilabs.com', registryCredential) {

						def customImage = docker.build("${registry}:${BUILD_NUMBER}")

						/* Push the container to the custom Registry */
						customImage.push()
						customImage.push('latest')
					}
                }
            }
        }
        stage('Remove docker images') {
            steps{
                sh "docker rmi $registry:$BUILD_NUMBER"
                // sh "docker rmi $registry:latest"
            }
        }

    */
        stage('echo') {
            steps{
                sh "echo"
                // sh "docker rmi $registry:latest"
            }
        }

    }
}
