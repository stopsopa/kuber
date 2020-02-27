
** install

    # create jenkins user
        adduser -m --system --shell '/bin/bash' --home-dir /home/jenkins jenkins
        usermod -aG docker jenkins
        cat /etc/passwd
        id

    # configure kubectl for user jenkins
        su jenkins
        doctl auth init
        doctl kubernetes cluster list
        doctl kubernetes cluster kubeconfig save k8s-cluster

    # open port

        sudo firewall-cmd --zone=public --add-port=8081/tcp --permanent
        sudo firewall-cmd --reload

    # optional sudo yum update -y && sudo yum install -y java-11-openjdk
        yum install -y java-1.8.0-openjdk
        java -version
            # should output: openjdk version "1.8.0_242"

    # from: https://jenkins.io/doc/pipeline/tour/getting-started/
        cd
        mkdir jenkins && cd jenkins
        wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war

        java -jar jenkins.war --httpPort=8081

            # from output:
                /root/.jenkins/secrets/initialAdminPassword
                https://i.imgur.com/TMrGNLs.png

    # register service: https://www.linode.com/docs/quick-answers/linux/start-service-at-boot/

cat <<EOF > /lib/systemd/system/jen.service
[Unit]
Description=Jenkins service - jenkins user

[Service]
User=jenkins
Type=simple
ExecStart=/usr/bin/java -jar /home/jenkins/jenkins/jenkins.war --httpPort=8082

[Install]
WantedBy=multi-user.target
EOF

    # to get initial password
    cat /home/jenkins/.jenkins/secrets/initialAdminPassword
        or use
        journalctl


sudo chmod 644 /lib/systemd/system/jenkins.service
ls -la /lib/systemd/system/jenkins.service
sudo systemctl start jen
sudo systemctl enable jen









