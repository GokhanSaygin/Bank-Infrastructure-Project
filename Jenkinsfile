pipeline {
    agent any
    
    environment {
        // AWS Credentials
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        
        // Environment-based configuration
        TF_VAR_environment = "${BRANCH_NAME == 'main' ? 'prod' : BRANCH_NAME == 'staging' ? 'staging' : 'dev'}"
        
        // VPC CIDR - farklı environment'lar için farklı network'ler
        TF_VAR_vpc_cidr = "${BRANCH_NAME == 'main' ? '10.0.0.0/16' : BRANCH_NAME == 'staging' ? '10.2.0.0/16' : '10.1.0.0/16'}"
        
        // Public Subnets
        TF_VAR_public_subnet_cidr = "${BRANCH_NAME == 'main' ? '10.0.1.0/24' : BRANCH_NAME == 'staging' ? '10.2.1.0/24' : '10.1.1.0/24'}"
        TF_VAR_public_subnet_2_cidr = "${BRANCH_NAME == 'main' ? '10.0.2.0/24' : BRANCH_NAME == 'staging' ? '10.2.2.0/24' : '10.1.2.0/24'}"
        
        // Private Application Subnets
        TF_VAR_private_app_subnet_1_cidr = "${BRANCH_NAME == 'main' ? '10.0.11.0/24' : BRANCH_NAME == 'staging' ? '10.2.11.0/24' : '10.1.11.0/24'}"
        TF_VAR_private_app_subnet_2_cidr = "${BRANCH_NAME == 'main' ? '10.0.12.0/24' : BRANCH_NAME == 'staging' ? '10.2.12.0/24' : '10.1.12.0/24'}"
        
        // Private Database Subnets
        TF_VAR_private_db_subnet_1_cidr = "${BRANCH_NAME == 'main' ? '10.0.21.0/24' : BRANCH_NAME == 'staging' ? '10.2.21.0/24' : '10.1.21.0/24'}"
        TF_VAR_private_db_subnet_2_cidr = "${BRANCH_NAME == 'main' ? '10.0.22.0/24' : BRANCH_NAME == 'staging' ? '10.2.22.0/24' : '10.1.22.0/24'}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo "🔄 Checking out code from branch: ${BRANCH_NAME}"
                checkout scm
            }
        }
        
        stage('Terraform Init') {
            steps {
                echo "🚀 Initializing Terraform for environment: ${TF_VAR_environment}"
                sh "terraform init -reconfigure -backend-config=\"key=bank-infra/${BRANCH_NAME}.tfstate\""
            }
        }
        
        stage('Terraform Validate') {
            steps {
                echo "✅ Validating Terraform configuration"
                sh 'terraform validate'
            }
        }
        
        stage('Terraform Plan') {
            steps {
                echo "📋 Planning Terraform changes"
                sh 'terraform plan -out=tfplan'
            }
        }
        
        stage('Manual Approval - Staging') {
            when {
                branch 'staging'
            }
            steps {
                script {
                    echo "⏸️  Waiting for approval to deploy to STAGING environment"
                    input message: 'Deploy to Staging?', 
                          ok: 'Deploy',
                          submitter: 'admin'
                }
            }
        }
        
        stage('Manual Approval - Production') {
            when {
                branch 'main'
            }
            steps {
                script {
                    echo "⏸️  Waiting for approval to deploy to PRODUCTION environment"
                    input message: 'Deploy to Production? This will affect live banking infrastructure!', 
                          ok: 'Deploy to Production',
                          submitter: 'admin'
                }
            }
        }
        
        stage('Terraform Apply') {
            when {
                anyOf {
                    branch 'main'
                    branch 'staging'
                    branch 'develop'
                }
            }
            steps {
                echo "🚀 Applying Terraform changes to ${TF_VAR_environment}"
                sh 'terraform apply -auto-approve tfplan'
            }
        }
        
        stage('Post-Deploy Verification') {
            when {
                anyOf {
                    branch 'main'
                    branch 'staging'
                    branch 'develop'
                }
            }
            steps {
                echo "✅ Verifying deployment"
                sh 'terraform output'
            }
        }
    }
    
    post {
        success {
            echo "✅ Pipeline completed successfully for ${TF_VAR_environment} environment!"
        }
        failure {
            echo "❌ Pipeline failed for ${TF_VAR_environment} environment!"
        }
        always {
            echo "🧹 Cleaning up workspace"
            cleanWs()
        }
    }
}