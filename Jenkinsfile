pipeline {
    agent {
        label 'docker'
    }
    stages {
        stage("Build App") {
            steps { 
                script {
                    def NS = input(id: 'Input_ns', message: 'Please, enter the namespace:', parameters: [choice(choices: ['maloglazov'], name: 'KUBENAMESPACE')])
                    echo ("NS is ${NS}")
                    KUBENAMESPACE=NS
                }
                sh 'echo $KUBENAMESPACE'
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
             when {
                 not {
                     branch 'master'
                 }
             }
            steps{

                withDockerRegistry(credentialsId: 'docker_hub', url: 'https://index.docker.io/v1/') {
                sh '''
                docker push multiflexer/java-app-hw2
                '''
                }
            } 
        }
        stage('Deploy'){
        when {
            branch 'master'
            }
        steps {
            withKubeConfig(credentialsId: 'kube_cred_1') {
                sh 'echo "This is NS!!${KUBENAMESPACE}"'//'kubectl -n ${KUBENAMESPACE} apply -f Job.yaml'   
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
