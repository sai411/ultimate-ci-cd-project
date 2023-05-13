pipeline {
    agent {
        docker {
            image 'abhishekf5/maven-abhishek-docker-agent:v1'
            args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    stages {
        stage('git checkout') {
            steps {
                echo 'Hello World'
            }
        }
        stage('build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('docker-build') {
            environment {
                DOCKER_IMAGE = "sai411/spring-boot-java-app:${env.BUILD_NUMBER}"
            }
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                    def docker_image = docker.image("${DOCKER_IMAGE}")
                    docker.withRegistry('https://registry.hub.docker.com', "docker-cred") {
                        docker_image.push()
                    }
                }
            }
        }
        stage('update manifestfile') {
            steps {
                withCredentials([gitUsernamePassword(credentialsId: '3d567b1b-b8d3-490d-95f2-1a10870cb340', gitToolName: 'Default')]) {
                    sh '''
                        git config user.email "saisatyanarayanagampa@gmail.com"
                        git config user.name "sai411"
                        cat manifestfiles/config_map.yml
                        BUILD_NUMBER=${BUILD_NUMBER}
                        echo $BUILD_NUMBER
                        sed -i "s/version: .*/version: \\"${BUILD_NUMBER}\\"/" manifestfiles/config_map.yml
                        git status
                        git add manifestfiles/config_map.yml
                        git commit -m "Updated config_map.yml with image version"
                        git push origin HEAD:main
                    '''
                }
            }
        }
    }
}
