pipeline {
    agent any 

    environment {
        MAKE_WEBHOOK_URL = credentials('make-webhook-url')
    }

    stages {
        stage('Install Tools') {
            steps {
                sh '''
                  sudo apt update
                  sudo apt install -y pylint bc
                '''
            }
        }

        stage('Static Code Analysis') {
            steps {
                sh '''
                  echo "Running pylint on app/app.py..."

                  SCORE=$(pylint app/app.py | awk '/rated at/ {print $7}' | cut -d'/' -f1)
                  echo "Pylint score: $SCORE"

                  if [ "$(echo "$SCORE < 7.0" | bc -l)" -eq 1 ]; then
                    echo "Pylint score too low"
                    exit 1
                  else
                    echo "Pylint score OK"
                  fi
                '''
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

