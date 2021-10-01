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
        AWS_ECS_EXECUTION_ROLE = 'arn:aws:iam::313583066119:role/ecsTaskExecutionRole'
        AWS_ECR_REGION = 'us-east-2'
        AWS_ECS_TASK_DEFINITION  = 'spc-taskdefinition'
        AWS_ECS_COMPATIBILITY = 'FARGATE'
        AWS_ECS_NETWORK_MODE = 'awsvpc'
        AWS_ECS_CPU = '256'
        AWS_ECS_MEMORY = '512'
        AWS_ECS_CLUSTER = 'dev'
        AWS_ECS_TASK_DEFINITION_PATH = './ecs/container-definition-update-image.json'
    }
   
    stages {
        stage('Build') {
            steps { 
                echo "--------Building Sprint-PetClinic application---------------------"
                echo "BUILD_NUMBER = ${BUILD_NUMBER}"
                echo "M2_HOME = ${M2_HOME}"                               
            //!    sh "'${M2_HOME}/bin/mvn' package"
            }
        }
        stage('Create Artifact'){
            when { expression { BRANCH_NAME == 'dev' || BRANCH_NAME == 'main' } }
            steps {
                echo "--------Create Docker Artifact-----------------"
              //!  sh "docker build -t ${AWS_ACCOUNT_ID}.${AWS_ECR_URL}/${APPLICATION_NAME}:${BUILD_NUMBER} ."
                
                echo "Push Docker Image to ECR"
                script {
                    docker.withRegistry("https://${AWS_ACCOUNT_ID}.${AWS_ECR_URL}", "ecr:${AWS_ECR_REGION}:AWS_ECR") {
                         //sh "docker push ${AWS_ACCOUNT_ID}.${AWS_ECR_URL}/${APPLICATION_NAME}:${BUILD_NUMBER}"
                        sh "docker push ${AWS_ACCOUNT_ID}.${AWS_ECR_URL}/${APPLICATION_NAME}:8" //!!!! ${BUILD_NUMBER}
                    }
                }
            }
        }        
        stage('Deploy in ECS') {
            when { expression { BRANCH_NAME == 'dev' || BRANCH_NAME == 'main' } }
            steps {
                echo "--------Deploying Docker Image from ECR to ECS cluster-----------------"
                withAWS(credentials:'AWS_ECR') {
                    script {
                        updateContainerDefinitionJsonWithImageVersion()
                        echo "Registering ECS Task Definition"
                        sh("/usr/bin/aws ecs register-task-definition --region ${AWS_ECR_REGION} --family ${AWS_ECS_TASK_DEFINITION} --execution-role-arn ${AWS_ECS_EXECUTION_ROLE} --requires-compatibilities ${AWS_ECS_COMPATIBILITY} --network-mode ${AWS_ECS_NETWORK_MODE} --cpu ${AWS_ECS_CPU} --memory ${AWS_ECS_MEMORY} --container-definitions file://${AWS_ECS_TASK_DEFINITION_PATH}")
                          
                        echo "Describing ECS Task Definition"
                        def taskRevision = sh(script: "/usr/bin/aws ecs describe-task-definition --task-definition ${AWS_ECS_TASK_DEFINITION} --region ${AWS_ECR_REGION} | egrep \"revision\" | tr \"/\" \" \" | awk '{print \$2}' | sed 's/.\$//'", returnStdout: true)
                        
                        echo "Updating ECS Service"
                        sh("/usr/bin/aws ecs update-service --cluster ${AWS_ECS_CLUSTER} --service ${APPLICATION_NAME} --region ${AWS_ECR_REGION} --task-definition ${AWS_ECS_TASK_DEFINITION}:${taskRevision}")
                        echo "Completed"
                    }
                }
            }
        }               
    }
}

def updateContainerDefinitionJsonWithImageVersion() {
    def containerDefinitionJson = readJSON file: AWS_ECS_TASK_DEFINITION_PATH, returnPojo: true
    //!containerDefinitionJson[0]['image'] = "${AWS_ACCOUNT_ID}.${AWS_ECR_URL}/${APPLICATION_NAME}:${BUILD_NUMBER}".inspect()
    containerDefinitionJson[0]['image'] = "${AWS_ACCOUNT_ID}.${AWS_ECR_URL}/${APPLICATION_NAME}:8".inspect() //!!!! ${BUILD_NUMBER}
    echo "task definiton json: ${containerDefinitionJson}"
    writeJSON file: AWS_ECS_TASK_DEFINITION_PATH, json: containerDefinitionJson
}


