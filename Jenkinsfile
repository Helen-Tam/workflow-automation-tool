pipeline {
    agent any

    environment {
        MAKE_WEBHOOK_URL = credentials('make-webhook-url')
    }

    stages {
        stage('Build') {
            steps {
                sh 'echo Building...'
            }
        }

        stage('Test') {
            steps {
                sh 'echo Testing...'
                // sh 'exit 1'   // uncomment to simulate failure
            }
        }
    }

    post {
        success {
            sh 'ci/notify.sh SUCCESS $MAKE_WEBHOOK_URL'
        }
        failure {
            sh 'ci/notify.sh FAILURE $MAKE_WEBHOOK_URL'
        }
    }
}