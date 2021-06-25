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
        stage("Test and Scan parallel"){
        parallel {
        stage("Tests") {
            when {
                not {
                    branch 'main'
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
                    branch 'main'
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
                     branch 'main'
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
        //when {
        //    branch 'master'
        //    }
        steps {
            script {
                def NS = input(id: 'Input_ns', message: 'Please, enter the namespace:', parameters: [choice(choices: ['maloglazov'], name: 'KUBENAMESPACE')])
                env.KUBENAMESPACE="${NS}"
            }
            withCredentials([kubeconfigFile(credentialsId: 'kube_cred_1', variable: 'KUBECONFIG')]) {    
                sh 'helm install --namespace ${KUBENAMESPACE} hw2 helm_chart/'   
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
