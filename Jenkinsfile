pipeline {
    agent {
        label 'docker'
    }
    stages {
        stage("Build App") {
            steps {
                sh 'docker build -t multiflexer/java-app .'
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
                    image 'multiflexer/java-app'
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
