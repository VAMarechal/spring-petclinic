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
                
//                echo "Create Build folder..." 
//                sh 'mkdir build'
//                echo "Execute build script..." 
//                sh "chmod +x -R ${env.WORKSPACE}"
//                sh "./make.sh"
//                echo "Script executed successfully!"
//                echo "Copying ready site to Build folder" 
//                sh 'cp -r img build'
//                sh 'cp -r lib build'
            }
        }
        stage('Create Artifact'){
            steps {
                echo "--------Create Artifact-----------------"
                sh "docker build -t spring_petclinic:${BUILD_NUMBER} ."
                sh "docker tag spring_petclinic:${BUILD_NUMBER} 18.191.142.161:8123/spring_petclinic:${BUILD_NUMBER}"    
                sh "docker push 18.191.142.161:8123/spring_petclinic:${BUILD_NUMBER}"
            }
        }
        stage('Deploy'){
            steps {
                echo "--------Deploy ------------------------"
            }
        }
    }
}
