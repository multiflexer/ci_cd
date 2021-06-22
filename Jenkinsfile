pipeline {
    agent {
        label 'docker'
    }
    stages {
        stage("Build App") {
            steps {
                sh 'printenv'
                sh 'docker build -t multiflexer/java-app-hw2 .'
            }
        }
        stage("Test and Scan parallel"){
        parallel {
        stage("Tests") {
            when {
                not {
                    branch 'master'
                }
            }
            agent {
                docker {
                    image 'multiflexer/java-app-hw2'
                    label 'docker'
                }
            }
            steps {
                sh '''
                mvn test
                '''
            }
        }
        stage("Scan") {
            when {
                not {
                    branch 'master'
                }
            }
            steps {
            sh '''
            trivy image multiflexer/java-app-hw2
            '''
            }
        }
        }
        }
        stage('Docker push'){
            steps{
                withDockerRegistry(credentialsId: 'docker_hub', url: 'https://index.docker.io/v1/') {
                sh '''
                docker push multiflexer/java-app-hw2
                '''
                }
            } 
        }
    }
    post {
        cleanup {
            cleanWs()
        }
    }
}
