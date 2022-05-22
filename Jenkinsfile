pipeline {
    
    tools {
        maven 'Maven3'
    }
    
    environment {
    //once you sign up for Docker hub, use that user_id here
        registry = "rashoow/calculator-app"
    //- update your credentials ID after creating credentials for connecting to Docker Hub
        registryCredential = 'e5b70cd2-4c19-4415-973d-3ac99b087041'
    dockerImage = ''
    // Docker TAG
        DOCKER_TAG = getVersion()
    }
    
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: 
                [[url: 'https://github.com/rashoow/JavaCalculatorApp']]])
            }
        }
        
        
        stage('Build Jar') {
            steps{
                    sh 'mvn -f JavaCalculatorApp/pom.xml clean install'
            }
        }
        
        
        stage ('Build docker image') {
            steps {
                    sh "docker build . -t $registry:${DOCKER_TAG}"
            }
        }
        
        
        stage ('DEV Deploy') {
           steps {
                 deploy adapters: [tomcat9(credentialsId: '685c512f-71ba-443c-b49e-f1ba86491053', path: '', url: 'http://ec2-44-204-98-230.compute-1.amazonaws.com:8080')], contextPath: null, war: '**/*.war'
            }
        }
        
        
        // Uploading Docker images into Docker Hub
        stage('Upload Image') {
            steps{
                script {
                        docker.withRegistry( '', registryCredential ) {
                        sh "docker push $registry:${DOCKER_TAG}"
                    }
                }
            }
        }
            
            
        stage('Cleaning up') {
            steps{
                sh "docker rmi $registry:${DOCKER_TAG}"
            }
        }
        

       stage('Docker Run') {
           steps{
               script {
                      sh 'docker run --name calculator-app -d -p 8096:8080 --rm $registry:${DOCKER_TAG}'
               }
            }
          }
         
        stage ('K8S Deploy') {
            steps {
                script {
                        withKubeConfig(caCertificate: '', clusterName: '', contextName: '', 
                        credentialsId: 'K8S', namespace: '', serverUrl: '') {
                        sh "kubectl apply -f kubernetes_file"
                    }
                }
            }
        }
        
        stage('Ingress Deploy') {
            steps{  
                script {
                    withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'K8S', namespace: '', serverUrl: '') {
                    sh ('kubectl apply -f  calculator-app-ingress.yaml')
                    }
                }
            }
        }         
    }
}


def getVersion() {
    def commitHash = sh label: '', returnStdout: true, script: 'git rev-parse --short HEAD'
    return commitHash
}
