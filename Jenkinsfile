pipeline
{
    agent any
     environment {
        registry = "230336210248.dkr.ecr.us-east-1.amazonaws.com/repoforecr"
    }
    stages{
        stage('Checkout'){
        steps{
    
            checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/techay-mihir-simform/demo_python_project.git']]])
        
        }   
         }
        stage('clone'){
            steps{
                sh '''
                rm -rf demo_python_project
                git clone https://github.com/techay-mihir-simform/demo_python_project.git
                '''
            }
        }
        stage('Build')
        {
            steps{
                script {
                        dockerImage = docker.build registry
                        }
            }
        }
        stage('Push to ECR'){
            steps{
                script {
                sh 'docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 230336210248.dkr.ecr.us-east-1.amazonaws.com'
                sh 'docker push 230336210248.dkr.ecr.us-east-1.amazonaws.com/repoforecr:latest'
         
         }
            }
        }
          stage('New_task'){
              steps{
                  sh '''
                  ls -al
                  aws --version
                  aws ecs register-task-definition --cli-input-json file://./container-def-cli.json 
                  '''
              }
          }  
//         stage('Stop Existing task'){
//             steps{
//             sh '''
//             aws ecs stop-task --cluster "ecscluster" --task $(aws ecs list-tasks --cluster "ecscluster" --service "web-service1" --output text --query taskArns[0])
//             '''
//             }
        
//         }
          stage('Update_service'){
              steps{
                  sh '''
                  aws ecs update-service --cluster ecscluster --service web-service1 --task-definition web-family --force-new-deployment
                  ''' 
              } 
          }
        
    }
}
