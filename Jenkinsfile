pipeline {
    agent any
    
    environment {
        // Jenkins Credentials ID'lerinin bu isimlerle kayıtlı oldugundan emin ol
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        
        TF_VAR_environment = "${BRANCH_NAME == 'main' ? 'prod' : 'dev'}"
        TF_VAR_vpc_cidr    = "${BRANCH_NAME == 'main' ? '10.0.0.0/16' : '10.1.0.0/16'}"
        TF_VAR_subnet_cidr = "${BRANCH_NAME == 'main' ? '10.0.1.0/24' : '10.1.1.0/24'}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh "terraform init -reconfigure -backend-config=\"key=bank-infra/${BRANCH_NAME}.tfstate\""
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            when {
                anyOf {
                    branch 'main'
                    branch 'dev'
                }
            }
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }
}