pipeline {
    agent any
    
    environment {
        registryCredential = 'awsecrdemo'
        appRegistry = '485490367164.dkr.ecr.ap-south-1.amazonaws.com/demo'
        awsRegistry = "https://485490367164.dkr.ecr.ap-south-1.amazonaws.com"
        cluster = "demo"
        service = "demo-svc"
    }

    stages {
        stage('Build App Image') {
            steps {
                script {
                    dockerImage = docker.build( appRegistry + ":$BUILD_NUMBER", "./")
                }
            }
        }

        stage('Docker login') {
            steps {
                script {
                   sh 'aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 485490367164.dkr.ecr.ap-south-1.amazonaws.com'
                }
            }
        }
       stage('Upload App Image') {
          steps{
            script {
                dockerImage.push("$BUILD_NUMBER")
                dockerImage.push('latest')
              }
            }
          }
        stage('Deploy to ECS') {
            steps {
                withAWS(credentials: 'awsecrdemo', region: 'ap-south-1') {
                    sh 'aws ecs update-service --cluster ${cluster} --service ${service} --force-new-deployment'
                }
            }
        }
    }
}
