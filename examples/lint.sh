# URL For your Jenkins instance
JENKINS_URL=http://34.76.134.148:8080
# Username for your account on the Jenkins server
USERNAME=admin
# Password for your account on the Jenkins server
PASSWORD=admin
# The Curl itself
curl --user $USERNAME:$PASSWORD -X POST -F "jenkinsfile=<Jenkinsfile" $JENKINS_URL/pipeline-model-converter/validate
