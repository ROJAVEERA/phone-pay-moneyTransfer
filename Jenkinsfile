pipeline{
agent any
  stages {
    stage ('checkout'){
      steps{
        git credentialsId: 'github-credentials', url: 'https://github.com/ROJAVEERA/phone-pay-moneyTransfer.git'
      }
    }
    stage ('build'){
      steps{
       sh 'mvn clean install'
      }
    }
     stage ('Build Docker image'){
      steps{
       sh "docker build -t rojakumaridocker/phone-pay-moneytransfer:${params.getDockerTag} ."
      }
    }
    stage ('Push to Docker hub'){
      steps{
        withCredentials([string(credentialsId: 'rojadockerpwd', variable: 'Dockerpwd')]) {
          sh "docker login -u rojakumaridocker -p ${Dockerpwd}"
          sh "docker push rojakumaridocker/phone-pay-moneytransfer:${params.getDockerTag}"
        } 
      }
    }
    stage ('deploy on k8s'){
      steps{
       sh "chmod +x changeTag.sh"
       sh "./changeTag.sh ${params.getDockerTag}"
        sshagent(['kubernetes-machine']) {
          sh "scp -o StrictHostKeyChecking=no kubernetes-deploy.yml kubernetes-svc.yml ubuntu@3.7.71.77:/home/ubuntu/"
          sh "ssh ubuntu@3.7.71.77 kubectl apply -f kubernetes-deploy.yml"
          sh "ssh ubuntu@3.7.71.77 kubectl apply -f kubernetes-svc.yml"
       }       
      }
    }
  }
}
