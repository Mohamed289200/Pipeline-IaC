pipeline {
    agent any

    // ── Build Parameters ──────────────────────────────────────────
    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'stag', 'prod'],
            description: 'Select the target deployment environment'
        )
    }

    // ── Environment Variables ─────────────────────────────────────
    environment {
        AWS_CREDENTIALS_ID = 'aws-credentials'   // Jenkins credential ID (AWS key/secret)
        TF_VAR_FILE        = "${params.ENVIRONMENT}.tfvars"
        BACKEND_KEY        = "${params.ENVIRONMENT}/terraform.tfstate"
        TF_IN_AUTOMATION   = 'true'
    }

    stages {

        // ── Stage 1: Checkout ─────────────────────────────────────
        stage('Checkout Source Code') {
            steps {
                echo "📥 Checking out source code for environment: ${params.ENVIRONMENT}"
                checkout scm
            }
        }

        // ── Stage 2: Terraform Init ───────────────────────────────
        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class           : 'AmazonWebServicesCredentialsBinding',
                    credentialsId    : "${AWS_CREDENTIALS_ID}",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    echo "🔧 Initializing Terraform with backend key: ${BACKEND_KEY}"
                    sh """
                        terraform init -reconfigure \
                            -backend-config="key=${BACKEND_KEY}"
                    """
                }
            }
        }

        // ── Stage 3: Terraform Format Check ──────────────────────
        stage('Terraform Format') {
            steps {
                echo "🎨 Checking Terraform formatting..."
                sh 'terraform fmt -check -recursive'
            }
        }

        // ── Stage 4: Terraform Validate ───────────────────────────
        stage('Terraform Validate') {
            steps {
                withCredentials([[
                    $class           : 'AmazonWebServicesCredentialsBinding',
                    credentialsId    : "${AWS_CREDENTIALS_ID}",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    echo "✅ Validating Terraform configuration..."
                    sh 'terraform validate'
                }
            }
        }

        // ── Stage 5: Terraform Plan ───────────────────────────────
        stage('Terraform Plan') {
            steps {
                withCredentials([[
                    $class           : 'AmazonWebServicesCredentialsBinding',
                    credentialsId    : "${AWS_CREDENTIALS_ID}",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    echo "📋 Running Terraform plan for: ${TF_VAR_FILE}"
                    sh """
                        terraform plan \
                            -var-file="${TF_VAR_FILE}" \
                            -out=tfplan
                    """
                }
            }
        }

        // ── Stage 6: Manual Approval ──────────────────────────────
        stage('Manual Approval') {
            steps {
                timeout(time: 15, unit: 'MINUTES') {
                    input(
                        message: "🚀 Deploy to ${params.ENVIRONMENT} environment?",
                        ok     : 'Approve & Apply'
                    )
                }
            }
        }

        // ── Stage 7: Terraform Apply ──────────────────────────────
        stage('Terraform Apply') {
            steps {
                withCredentials([[
                    $class           : 'AmazonWebServicesCredentialsBinding',
                    credentialsId    : "${AWS_CREDENTIALS_ID}",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    echo "🏗️ Applying Terraform plan to: ${params.ENVIRONMENT}"
                    sh 'terraform apply tfplan'
                }
            }
        }

        // ── Stage 8: Terraform Outputs ────────────────────────────
        stage('Terraform Outputs') {
            steps {
                withCredentials([[
                    $class           : 'AmazonWebServicesCredentialsBinding',
                    credentialsId    : "${AWS_CREDENTIALS_ID}",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    echo "📤 Fetching Terraform outputs..."
                    sh 'terraform output'
                }
            }
        }
    }

    // ── Post Actions ──────────────────────────────────────────────
    post {
        success {
            echo "✅ Pipeline finished successfully for environment: ${params.ENVIRONMENT}"
        }
        failure {
            echo "❌ Pipeline FAILED for environment: ${params.ENVIRONMENT}"
        }
        always {
            cleanWs()
        }
    }
}
