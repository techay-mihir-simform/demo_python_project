properties([pipelineTriggers([githubPush()])])
pipeline {
    agent any

    stages {
        stage('Checkout SCM') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: 'main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/MeetManvar/spm.git',
                        credentialsId: '',
                    ]]
                ])
            }
        }
        stage('Clone'){
            steps{
                
                sh "rm -rf spm" 

                sh "git clone https://github.com/MeetManvar/spm.git"

            }
        }
     
        stage('Build'){
            steps{

                sh ''' docker login -u AWS -p $(aws ecr-public get-login-password --region us-east-1) public.ecr.aws/i4y9b5h8 '''

                
                sh """ 
                    cd spm/ &&

                    docker build -t public.ecr.aws/i4y9b5h8/spm:latest . """
                
            }
        }

        stage('Push'){
            steps{

                sh " docker push public.ecr.aws/i4y9b5h8/spm:latest "
                
            }
        }
        stage('Stop Existing Task') {
            steps {
               //sh ''' echo "Stopped Existing Task" '''
                sh '''aws ecs stop-task --cluster "myapp-cluster" --task $(aws ecs list-tasks --cluster "myapp-cluster" --service "testapp-service" --output text --query taskArns[0]) '''
            }
        }

        stage('Update Service') {
            steps {
               //sh ''' echo "Service Updated Successfully" '''
                sh ''' aws ecs update-service --cluster myapp-cluster --service testapp-service --task-definition testapp-task --force-new-deployment '''
            }
        }
    }
}
