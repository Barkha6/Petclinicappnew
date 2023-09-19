pipeline {
    agent any
    tools{
        maven 'mvn'
    }
    
    environment {
        SCANNER_HOME=tool 'sonarqube-server'
        registryCredential = 'awsecrdemo'
        appRegistry = '485490367164.dkr.ecr.ap-south-1.amazonaws.com/demo'
        awsRegistry = "https://485490367164.dkr.ecr.ap-south-1.amazonaws.com"
        cluster = "demo"
        service = "demo-svc"
    }

    stages {
        stage("Compile"){
            steps{
                sh "mvn clean compile"
            }
        }
        
         stage("Test Cases"){
            steps{
                sh "mvn test"
            }
        }
        
        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('sonarqube-server') {
                    sh ''' $SCANNER_HOME/bin/sonarqube-server -Dsonar.projectName=Petclinic \
                    -Dsonar.java.binaries=. \
                    -Dsonar.projectKey=Petclinic '''
    
                }
            }
        }
        stage("Build"){
            steps{
                sh " mvn clean install"
            }
        }
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
