aws autoscaling create-launch-configuration \
--launch-configuration-name <launch_configuration_name> \
--image-id <ami_id> --instance-type <instance_type> \
--security-groups <security_group_id> --key-name <key_name>

aws elbv2 create-target-group --name <target_group_name> \
--protocol HTTP --port 80 --target-type instance --vpc-id <vpc_id>

aws elbv2 create-load-balancer --name <load_balancer_name> \
 --subnets <subnet_id_1> <subnet_id_2> --security-groups <security_group_id> \
 --scheme internet-facing --type application --ip-address-type ipv4 \
 --tags Key=Name,Value=<load_balancer_name> Key=Environment,Value=Production \
 --no-cli-pager

aws elbv2 create-listener --load-balancer-arn <load_balancer_arn> \
--protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=<target_group_arn>

aws autoscaling create-auto-scaling-group --auto-scaling-group-name <auto_scaling_group_name> \
--launch-configuration-name <launch_configuration_name> --target-group-arns <target_group_arn> \
 --min-size 2 --max-size 5 --desired-capacity 2 --vpc-zone-identifier <subnet_id>
