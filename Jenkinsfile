pipeline {
    agent {
        label 'docker'
    }
    stages {
        stage("Build App") {
            steps {
                sh 'docker build -t multiflexer/java-app-hw2 .'
            }
        }
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
    post {
        cleanup {
            cleanWs()
        }
    }
}
