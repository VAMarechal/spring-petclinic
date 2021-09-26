pipeline { 
    agent any 
    tools { 
        maven 'maven-3.8.2' 
        jdk 'java-8-openjdk-i386' 
    }
    
    stages {
        stage('Build') {
            steps { 
                echo "--------Building ---------------------"
                echo "BUILD_NUMBER = ${BUILD_NUMBER}"
                echo "M2_HOME = ${M2_HOME}"
                echo "$USER"
                
            //!    sh "'${M2_HOME}/bin/mvn' package"
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
                
                //sh "docker tag spring_petclinic:${BUILD_NUMBER} 18.224.180.211:8123/spring_petclinic:${BUILD_NUMBER}"    
                //sh "docker push 18.224.180.211:8123/spring_petclinic:${BUILD_NUMBER}"
            }
        }
        stage('Deploy'){
            steps {
                echo "--------Deploy ------------------------"
            }
        }
    }
}
