pipeline { 
    agent any 
    tools { 
        maven 'maven-3.8.2' 
        jdk 'java-8-openjdk-i386' 
    }
    
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

     environment {
         APPLICATION_NAME = 'spring_petclinic'
         AWS_ACCOUNT_ID = '313583066119'
         AWS_ECR_URL = 'dkr.ecr.us-east-2.amazonaws.com'
         AWS_ECR_REGION = 'us-east-2'
    }
   
    stages {
        stage('Build') {
            steps { 
                echo "--------Building Sprint-PetClinic application---------------------"
                echo "TAG= ${BRANCH_NAME}_${BUILD_NUMBER}"
                // echo "M2_HOME = ${M2_HOME}"                               
                sh "'${M2_HOME}/bin/mvn' package"
            }
        }
        stage('Create Artifact'){
            when { expression { BRANCH_NAME == 'dev' || BRANCH_NAME == 'main' } }
            steps {
                echo "--------Create Docker Artifact-----------------"
                sh "docker build -t ${AWS_ACCOUNT_ID}.${AWS_ECR_URL}/${APPLICATION_NAME}:${BRANCH_NAME}_${BUILD_NUMBER} ."
                
                echo "--------Push Docker Image to ECR---------------"
                script {
                    docker.withRegistry("https://${AWS_ACCOUNT_ID}.${AWS_ECR_URL}", "ecr:${AWS_ECR_REGION}:AWS_ECR") {
                        sh "docker push ${AWS_ACCOUNT_ID}.${AWS_ECR_URL}/${APPLICATION_NAME}:${BRANCH_NAME}_${BUILD_NUMBER}"
                    }
                }
                echo "--------Remove Local Docker Image -------------------"
                sh "docker rmi -f ${AWS_ACCOUNT_ID}.${AWS_ECR_URL}/${APPLICATION_NAME}:${BRANCH_NAME}_${BUILD_NUMBER}"
            }
        }        
        stage('Deploy in ECS') {
            when { expression { BRANCH_NAME == 'dev' || BRANCH_NAME == 'main' } }
            steps {
                echo "--------Deploying Docker Image from ECR to ECS cluster-----------------"
                build job: 'Spring Pet Clinic - Deploy', parameters: [                                     
                    string(name: 'selected_image', value: "${BRANCH_NAME}_${BUILD_NUMBER}"),
                    string(name: 'branch_name', value: "pet-${BRANCH_NAME}-cluster")
                ]
            }
        }               
    }
}
