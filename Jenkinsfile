pipeline { 
    agent any 
    stages {
        stage('Build') {
            steps { 
                echo "--------Building ---------------------"
                mvnHome = tool '/home/va/apache-maven-3.8.2'
                sh "'${mvnHome}/bin/mvn' clean package"
                // Publish JUnit Report
                junit '**/target/surefire-reports/TEST-*.xml'
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
            }
        }
        stage('Deploy'){
            steps {
                echo "--------Deploy ------------------------"
            }
        }
    }
}
