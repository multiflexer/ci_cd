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
    }
    post {
        cleanup {
            cleanWs()
        }
    }
}
