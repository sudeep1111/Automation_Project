# Automation_Project
Upgard_assignment

The following operations are carried out by this script:
1) Updating the packaging information
2) If the apache2 package is not already installed, immediately install it.
3) Check to see if the apache2 service is running.
4) Make sure the apache2 service is enabled.
5) Create a tar archive of the /var/log/apache2/ directory's access logs and error logs from Apache 2 and put it in the /tmp/ directory.
6) After copying the archive to the s3 bucket, the script should execute the AWS CLI command.
