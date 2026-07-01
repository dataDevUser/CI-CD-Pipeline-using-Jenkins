pipeline {
    agent any

    triggers {
        githubPush()
    }

    environment {
        VENV_DIR   = "venv"
        FLASK_PORT = "5000"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh '''
                    python3 -m venv $VENV_DIR
                    . $VENV_DIR/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Lint') {
            steps {
                sh '''
                    . $VENV_DIR/bin/activate
                    flake8 . --count --statistics
                '''
            }
        }

        stage('Test') {
            steps {
                sh '''
                    . $VENV_DIR/bin/activate
                    pytest -v --junitxml=test-reports/results.xml
                '''
            }
            post {
                always {
                    junit allowEmptyResults: true, testResults: 'test-reports/*.xml'
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'chmod +x deploy.sh && ./deploy.sh'
            }
        }
    }

    post {
        success {
            echo "Pipeline succeeded — Flask app deployed on port ${FLASK_PORT}"
        }
        failure {
            echo "Pipeline failed — check the stage logs above"
        }
    }
}
