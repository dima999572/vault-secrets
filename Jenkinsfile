pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: ubuntu
    image: ubuntu
    command:
    - sleep
    args:
    - infinity
    securityContext:
      runAsUser: 0
'''
            defaultContainer 'ubuntu'
            retries 2
        }
    }
    stages {
        stage('Main') {
            steps {
                script {
                    sh 'apt-get update && apt-get install -y curl'
                    withCredentials([string(credentialsId: 'artifactory-token', variable: 'ARTIFACTORY_TOKEN')]) {
                        def artifactoryUrl = "http://artifactory.artifactory.svc.cluster.local:8082"
                        
                        def response = sh(script: """
                            curl -H "Authorization: Bearer ${env.ARTIFACTORY_TOKEN}" \
                                "${artifactoryUrl}/artifactory/api/repositories" 
                        """, returnStdout: true).trim()
                        
                        echo "Artifactory Repositories: ${response}"
                    }
                }
            }
        }
    }
}
