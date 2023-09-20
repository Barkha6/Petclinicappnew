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
                  sh  "mvn clean verify sonar:sonar \
                      -Dsonar.projectKey=petclinicapp \
                      -Dsonar.login=sqp_d2e560f5bfe23f14ac5101b12b4defa461c31e88"
    
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
        stage("Deploy To Tomcat"){
            steps{
                sh "cp  /var/lib/jenkins/workspace/petclinicapp-new/target/spring-petclinic-2.7.3.war /opt/apache-tomcat-9.0.65/webapps/ "
            }
        }
    }
}
