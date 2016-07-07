# Bootstrap Livingdocs Infrastructure

### Bootstrap the infrastucture
```bash
./terraform create:<namespace>
```

### Apply updates
```bash
./terraform create:<namespace>
```

Yep, you've read that right. Just change the config and execute the same command again. But have attention. If you're changing some variables its resource gets completely recreated.

### Destroy
```bash
./terraform destroy:<namespace>
```

This deletes all your resources. This only works after you've used `create`.


### Example configuration

```bash
# ./environments/namespace/terraform.tfvars

# AWS credentials that supports cloudwatch, rds, ec2
aws_access_key="<KEY>"
aws_secret_key="<SECRET>"
aws_region="eu-west-1"

# Database
rancher_db_instance_name="rancher-production"
rancher_db_instance_class ="db.t2.micro"
rancher_db_zone = "eu-west-1a"
rancher_db_name="rancher_production"

# 1-16 alphanumeric chars, beginning with a letter
rancher_db_username = "<USERNAME>"

# 1-41 ascii characters, excluding @, ", /
rancher_db_password = "<PASSWORD>"

# only works with larger instances than db.t2.micro
# Use 30, 60, 90
rancher_db_monitoring_interval = "0"

# Rancher
# AWS AMI https://github.com/rancher/os/blob/master/README.md#amazon
rancher_os_ami="ami-997b1eea"
rancher_instance_type="t2.micro"
rancher_docker_image="rancher/server:v1.1.0"

# Licence key for server monitoring which is free, https://rpm.newrelic.com
new_relic_license_key="<KEY>"

# Rancher frontend
rancher_domain = "rancher.yourdomain.io"

# remove this config completely if you can't support ssl.
# On the first run you might want to remove this line because
# you probably can't set up the domain fast enough
# before letsencrypt is trying to configure the certificate
letsencrypt="tls your@email.com"
```
