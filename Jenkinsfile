pipeline {
    agent any

    // ── Build Parameters ──────────────────────────────────────────
    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'stag', 'prod'],
            description: 'Select the target deployment environment'
        )
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'Select action: apply (deploy) or destroy (teardown)'
        )
    }

    // ── Environment Variables ─────────────────────────────────────
    environment {
        AWS_CREDENTIALS_ID = 'aws-credentials'   // Jenkins credential ID (AWS key/secret)
        SSH_CREDENTIALS_ID = 'ssh-private-key'   // Jenkins credential ID (SSH private key)
        TF_VAR_FILE        = "${params.ENVIRONMENT}.tfvars"
        BACKEND_KEY        = "${params.ENVIRONMENT}/terraform.tfstate"
        TF_IN_AUTOMATION   = 'true'
    }

    stages {

        // ── Stage 1: Checkout ─────────────────────────────────────
        stage('Checkout Source Code') {
            steps {
                echo "📥 Checking out source code | ENV: ${params.ENVIRONMENT} | ACTION: ${params.ACTION}"
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
                        terraform init -reconfigure \\
                            -backend-config="key=${BACKEND_KEY}"
                    """
                }
            }
        }

        // ── Stage 3: Terraform Format Check (apply only) ─────────
        stage('Terraform Format') {
            when { expression { params.ACTION == 'apply' } }
            steps {
                echo "🎨 Checking Terraform formatting..."
                sh 'terraform fmt -check -recursive'
            }
        }

        // ── Stage 4: Terraform Validate (apply only) ──────────────
        stage('Terraform Validate') {
            when { expression { params.ACTION == 'apply' } }
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

        // ── Stage 5: Terraform Plan (apply only) ──────────────────
        stage('Terraform Plan') {
            when { expression { params.ACTION == 'apply' } }
            steps {
                withCredentials([
                    [
                        $class           : 'AmazonWebServicesCredentialsBinding',
                        credentialsId    : "${AWS_CREDENTIALS_ID}",
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ],
                    sshUserPrivateKey(
                        credentialsId  : "${SSH_CREDENTIALS_ID}",
                        keyFileVariable: 'SSH_KEY_FILE'
                    )
                ]) {
                    echo "📋 Running Terraform plan for: ${TF_VAR_FILE}"
                    sh """
                        export TF_VAR_private_key_content="\$(cat \$SSH_KEY_FILE)"
                        terraform plan \\
                            -var-file="${TF_VAR_FILE}" \\
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
                        message: params.ACTION == 'destroy'
                            ? "⚠️ DESTROY all resources in [${params.ENVIRONMENT}]? This is IRREVERSIBLE!"
                            : "🚀 Deploy to [${params.ENVIRONMENT}] environment?",
                        ok: params.ACTION == 'destroy' ? '🗑️ Yes, Destroy Everything' : 'Approve & Apply'
                    )
                }
            }
        }

        // ── Stage 7: Terraform Apply (apply only) ─────────────────
        stage('Terraform Apply') {
            when { expression { params.ACTION == 'apply' } }
            steps {
                withCredentials([
                    [
                        $class           : 'AmazonWebServicesCredentialsBinding',
                        credentialsId    : "${AWS_CREDENTIALS_ID}",
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ],
                    sshUserPrivateKey(
                        credentialsId  : "${SSH_CREDENTIALS_ID}",
                        keyFileVariable: 'SSH_KEY_FILE'
                    )
                ]) {
                    echo "🏗️ Applying Terraform plan to: ${params.ENVIRONMENT}"
                    sh """
                        export TF_VAR_private_key_content="\$(cat \$SSH_KEY_FILE)"
                        terraform apply tfplan
                    """
                }
            }
        }

        // ── Stage 8: Terraform Destroy (destroy only) ─────────────
        stage('Terraform Destroy') {
            when { expression { params.ACTION == 'destroy' } }
            steps {
                withCredentials([
                    [
                        $class           : 'AmazonWebServicesCredentialsBinding',
                        credentialsId    : "${AWS_CREDENTIALS_ID}",
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ],
                    sshUserPrivateKey(
                        credentialsId  : "${SSH_CREDENTIALS_ID}",
                        keyFileVariable: 'SSH_KEY_FILE'
                    )
                ]) {
                    echo "🗑️ Destroying all resources in: ${params.ENVIRONMENT}"
                    sh """
                        export TF_VAR_private_key_content="\$(cat \$SSH_KEY_FILE)"
                        terraform destroy \\
                            -var-file="${TF_VAR_FILE}" \\
                            -auto-approve
                    """
                }
            }
        }

        // ── Stage 9: Terraform Outputs (apply only) ───────────────
        stage('Terraform Outputs') {
            when { expression { params.ACTION == 'apply' } }
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
            echo "✅ Pipeline finished successfully | ENV: ${params.ENVIRONMENT} | ACTION: ${params.ACTION}"
        }
        failure {
            echo "❌ Pipeline FAILED | ENV: ${params.ENVIRONMENT} | ACTION: ${params.ACTION}"
        }
        always {
            cleanWs()
        }
    }
}
