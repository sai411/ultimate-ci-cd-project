pipeline {
    agent {
        docker{
            image 'abhishekf5/maven-abhishek-docker-agent:v1'
            args '--user root -v /var/run/docker.sock:/var/run/docker.sock' // mount Docker socket to access the host's Docker daemon
        }
    }

    stages {
        stage('git checkout') {
            steps {
                echo 'Hello World'
            }
        }
        stage('build'){
            steps{
              sh 'mvn clean package'
            }
        }
      stage('Static Code Analysis') {
      environment {
        SONAR_URL = "http://34.229.20.199:9000"
      }
      steps {
          withCredentials([string(credentialsId: 'SONAR_AUTH_TOKEN', variable: 'SONAR_AUTH_TOKEN')]) {
          sh  'mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}'
        }
      }
    }
        stage('docker-build'){
            environment {
              DOCKER_IMAGE = "sai411/spring-boot-java-app:${BUILD_NUMBER}"
              //REGISTRY_CREDENTIALS = credentials('docker-cred')
      }
            steps{
                script{
                sh 'docker build -t ${DOCKER_IMAGE} .'
                def docker_image = docker.image("${DOCKER_IMAGE}")
                docker.withRegistry('https://hub.docker.com', "docker-cred") {
                    docker_image.push()
                }
            }
            }
        }
    }
}
