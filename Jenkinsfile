pipeline {
  agent {
    docker {
      image 'iamsaikishore/maven-docker-agent:v1'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock' // mount Docker socket to access the host's Docker daemon
    }
  }
  stages {
    stage('Checkout') {
      steps {
        sh 'echo passed'
        git branch: 'main', url: 'https://github.com/iamsaikishore/Project8---Streamline-the-Deployment-of-Your-Ecommerce-Application-with-Kubernetes-Cluster.git'
      }
    }
    stage('Build and Push Docker Image') {
      environment {
        DOCKER_IMAGE = "iamsaikishore/${JOB_NAME}:${BUILD_NUMBER}"
        // DOCKERFILE_LOCATION = "./Dockerfile"
        REGISTRY_CREDENTIALS = credentials('docker-cred')
      }
      steps {
        script {
            sh 'docker build -t ${DOCKER_IMAGE} .'
            def dockerImage = docker.image("${DOCKER_IMAGE}")
            docker.withRegistry('https://index.docker.io/v1/', "docker-cred") {
                dockerImage.push()
            }
        }
      }
    }
    stage('Update Deployment File') {
        environment {
            GIT_REPO_NAME = "Project8---Streamline-the-Deployment-of-Your-Ecommerce-Application-with-Kubernetes-Cluster"
            GIT_USER_NAME = "iamsaikishore"
        }
        steps {
            withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                sh '''
                    git config user.email "saikishorepro28@gmail.com"
                    git config user.name "iamsaikishore"
                    BUILD_NUMBER=${BUILD_NUMBER}
                    // sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" manifests/deployment.yml
                    sed -i "19c \        image: iamsaikishore/$JOB_NAME:${BUILD_NUMBER}" manifests/deployment.yml
                    // sed -i -e "s/JOB_NAME:*/$JOB_NAME:${BUILD_NUMBER}/g" manifests/deployment.yml
                    git add manifests/deployment.yml
                    git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                    git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:master
                '''
            }
        }
    }
  }
}
