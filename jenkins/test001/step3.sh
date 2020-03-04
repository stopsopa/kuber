
source ~/.bash_profile 1>> log.log 2>> /dev/null


set -x
set -e

echo "SHELL: $SHELL, shell: $shell, ARGV[0]: $0, PS1: $PS1, prompt: $prompt"

ps -o command -p $$

env

_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"

source "$_DIR/../../.env"

echo ">>$ENVVARIABLE<<"

docker -v

docker ps

id

pwd

kubectl get node

# example output:
#+ /bin/bash jenkins/step3.sh
#SHELL: /bin/bash, shell: , ARGV[0]: jenkins/step3.sh, PS1: , prompt:
#COMMAND
#/bin/bash jenkins/step3.sh
#BUILD_URL=http://jenkins-domain.com:8081/job/jen/11/
#STAGE_NAME=Step 3
#BUILD_TAG=jenkins-jen-11
#GIT_PREVIOUS_COMMIT=8eb5769d06673e0031c53a3de33a7f1ff1032318
#WORKSPACE=/root/.jenkins/workspace/jen
#JOB_URL=http://jenkins-domain.com:8081/job/jen/
#RUN_CHANGES_DISPLAY_URL=http://jenkins-domain.com:8081/job/jen/11/display/redirect?page=changes
#JENKINS_HOME=/root/.jenkins
#GIT_COMMIT=d0d170e510f0d807a804204052af417461eca3da
#PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
#RUN_DISPLAY_URL=http://jenkins-domain.com:8081/job/jen/11/display/redirect
#PWD=/root/.jenkins/workspace/jen
#HUDSON_URL=http://jenkins-domain.com:8081/
#LANG=en_US.UTF-8
#JOB_NAME=jen
#BUILD_DISPLAY_NAME=#11
#JENKINS_URL=http://jenkins-domain.com:8081/
#BUILD_ID=11
#JOB_BASE_NAME=jen
#GIT_PREVIOUS_SUCCESSFUL_COMMIT=8eb5769d06673e0031c53a3de33a7f1ff1032318
#SHLVL=3
#GIT_BRANCH=origin/master
#JENKINS_SERVER_COOKIE=durable-cd4275d28ef248fca6a2704529da0644
#EXECUTOR_NUMBER=0
#GIT_URL=https://github.com/stopsopa/repository.git
#NODE_LABELS=master
#HUDSON_HOME=/root/.jenkins
#NODE_NAME=master
#JOB_DISPLAY_URL=http://jenkins-domain.com:8081/job/jen/display/redirect
#BUILD_NUMBER=11
#HUDSON_COOKIE=f8f7d8cd-d938-4ae4-bb75-eca86d4e1bb9
#_=/usr/bin/env
#>>envvar value<<
#Docker version 19.03.5, build 633a0ea
#CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                   NAMES
#73d1d2849d03        image_ownregistry   "/entrypoint.sh /etc…"   2 weeks ago         Up 2 weeks          0.0.0.0:443->5000/tcp   docker-registry
#uid=0(root) gid=0(root) groups=0(root) context=system_u:system_r:unconfined_service_t:s0
#/root/.jenkins/workspace/jen

