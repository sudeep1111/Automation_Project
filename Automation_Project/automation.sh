#!/bin/bash
set -x

 name=Sudeep
 s3_bucket=upgrad-sudeep
 
#Perform an update of the package details and the package list at the start of the script.
update_instances() {
        sudo apt update -y
        echo "update of the package completed"
        sleep 4
}

#Install the apache2 package if it is not already installed. (The dpkg and apt commands are used to check the installation of the packages.)
apache2_packager_installation() {
        echo "Check apache2 package installation"
        value=`dpkg --get-selections | grep apache | wc -l`
        if [ $value -eq 0 ]
        then
                echo "installing apache2"
                sudo apt-get install apache2
        else
                echo "Apache2 package already present"

        fi
}

#Ensure that the apache2 service is running.
apache2_runningstatus(){
        echo "validate if apache2 is running"
        value=`service --status-all | grep apache2 | wc -l`
        sleep 3
        if [ $value != 0 ]; then
                echo "apache2 is in running state."
        else
                echo "apache2 is not in  running state. Starting it"
                sudo service apache2 start
        fi
}

#Ensure that the apache2 service is enabled. (The systemctl or service commands are used to check if the services are enabled and running. Enabling apache2 as a service ensures that it runs as soon as our machine reboots. It is a daemon process that runs in the background.)
apache2service_enabled() {
       value=`systemctl status apache2.service| grep enabled | wc -l`
        sleep 3
        if [ $value != 0 ]; then
                echo "apache2 services is enabled."
        else
                echo "apache2 service is not enabled. Therefore enabling it"
        sudo systemctl enable apache2.service
        fi
}

#Create a tar archive of apache2 access logs and error logs that are present in the /var/log/apache2/ directory and place the tar into the /tmp/ directory. Create a tar of only the .log files (for example access.log) and not any other file type (For example: .zip and .tar) that are already present in the /var/log/apache2/ directory. The name of tar archive should have following format:  <your _name>-httpd-logs-<timestamp>.tar. For example: Ritik-httpd-logs-01212021-101010.tar

create_tar_archive() {
        echo "Starting the tar of apache2 logs"
        timestamp=$(date '+%d%m%Y-%H%M%S')
        tar -cvf /tmp/$name-httpd-logs-$timestamp.tar /var/log/apache2/*.log
        aws s3 cp /tmp/$name-httpd-logs-$timestamp.tar s3://$s3_bucket/$name-httpd-logs-$timestamp.tar
}




update_instances
apache2_packager_installation
apache2_runningstatus
apache2service_enabled
create_tar_archive

