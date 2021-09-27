pipeline { 
    agent any 
    tools { 
        maven 'maven-3.8.2' 
        jdk 'java-8-openjdk-i386' 
    }

     environment {
//        POM_VERSION = getVersion()
//        JAR_NAME = getJarName()
        AWS_ECR_URL = '313583066119.dkr.ecr.us-east-2.amazonaws.com/spring_petclinic'
        AWS_ECR_REGION = 'us-east-2'
        AWS_ECS_SERVICE = 'ch-dev-user-api-service'
        AWS_ECS_TASK_DEFINITION = 'ch-dev-user-api-taskdefinition'
        AWS_ECS_COMPATIBILITY = 'FARGATE'
        AWS_ECS_NETWORK_MODE = 'awsvpc'
        AWS_ECS_CPU = '256'
        AWS_ECS_MEMORY = '512'
        AWS_ECS_CLUSTER = 'ch-dev'
        AWS_ECS_TASK_DEFINITION_PATH = './ecs/container-definition-update-image.json'
    }
   
    stages {
        stage('Build') {
            steps { 
                echo "--------Building ---------------------"
                echo "BUILD_NUMBER = ${BUILD_NUMBER}"
                echo "M2_HOME = ${M2_HOME}"
                echo "$USER"
                
                sh "'${M2_HOME}/bin/mvn' package"
                // sh "'${M2_HOME}/bin/mvn' clean package"
                // Publish JUnit Report
                // junit '**/target/surefire-reports/TEST-*.xml'
            }
        }
        stage('Create Artifact'){
            steps {
                echo "--------Create Artifact-----------------"
                sh "docker build -t 313583066119.dkr.ecr.us-east-2.amazonaws.com/spring_petclinic:${BUILD_NUMBER} ."
                echo "--------Push to ACR-----------------"
                script {
                    docker.withRegistry(
                        'https://313583066119.dkr.ecr.us-east-2.amazonaws.com',
                        'ecr:us-east-2:AWS_ECR' ) {
                        sh "docker push 313583066119.dkr.ecr.us-east-2.amazonaws.com/spring_petclinic:${BUILD_NUMBER}"
                        // def mylmage = docker.bulld('spring_petclinic') 
                        // mylmage.push('${BUILD_NUMBER}' )
                    }
                }
            }
        }
        
        stage('Deploy in ECS') {
            steps {
                withCredentials([string(credentialsId: 'AWS_ECR', variable: 'AWS_ECS_EXECUTION_ROL')]) {
                    script {
                        updateContainerDefinitionJsonWithImageVersion()
                        sh("/usr/local/bin/aws ecs register-task-definition --region ${AWS_ECR_REGION} --family ${AWS_ECS_TASK_DEFINITION} --execution-role-arn ${AWS_ECS_EXECUTION_ROL} --requires-compatibilities ${AWS_ECS_COMPATIBILITY} --network-mode ${AWS_ECS_NETWORK_MODE} --cpu ${AWS_ECS_CPU} --memory ${AWS_ECS_MEMORY} --container-definitions file://${AWS_ECS_TASK_DEFINITION_PATH}")
                        def taskRevision = sh(script: "/usr/local/bin/aws ecs describe-task-definition --task-definition ${AWS_ECS_TASK_DEFINITION} | egrep \"revision\" | tr \"/\" \" \" | awk '{print \$2}' | sed 's/\"\$//'", returnStdout: true)
                        sh("/usr/local/bin/aws ecs update-service --cluster ${AWS_ECS_CLUSTER} --service ${AWS_ECS_SERVICE} --task-definition ${AWS_ECS_TASK_DEFINITION}:${taskRevision}")
                    }
                }
            }
        }
        
        stage('Deploy'){
            steps {
                echo "--------Deploy ------------------------"
                
            }
        }
    }
}
