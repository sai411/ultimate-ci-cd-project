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
        SONAR_URL = "http://54.225.1.203:9000"
      }
      steps {
          withCredentials([string(credentialsId: 'SONAR_AUTH_TOKEN', variable: 'SONAR_AUTH_TOKEN')]) {
          sh  'mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}'
        }
      }
    }
        stage('docker-build'){
            environment {
              DOCKER_IMAGE = "sai411/spring-boot-java-app:${env.BUILD_NUMBER}"
              // REGISTRY_CREDENTIALS = credentials('docker-cred')
      }
            steps{
                script{
                sh 'docker build -t ${DOCKER_IMAGE} .'
                def docker_image = docker.image("${DOCKER_IMAGE}")
                docker.withRegistry('https://registry.hub.docker.com', "docker-cred") {
                    docker_image.push()
                }
            }
            }
        }
    stage('update manifestfile'){
        steps{
             sh 'echo ${env.BUILD_NUMBER}'
             withCredentials([gitUsernamePassword(credentialsId: '3d567b1b-b8d3-490d-95f2-1a10870cb340', gitToolName: 'Default')]) {
             sh 
             '''
              git config user.email "saisatyanarayanagampa@gmail.com"
              git config user.name "sai411"
              sed -i 's/image: spring-boot-java-app:v1/image: spring-boot-java-app:${env.BUILD_NUMBER}/g' manifestfiles/deployment.yml
              git add manifestfiles/deployment.yml
              git commit -m "Updated deployment.yml with image version"
              git push origin main
             '''
            }
            }
    }
    }
}
