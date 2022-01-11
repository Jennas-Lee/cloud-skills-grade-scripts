#!/bin/bash

echo -e "2021 대전광역시 제56회 전국기능경기대회 제1과제 \"Web Service Provisioning\"를 채점합니다."
echo -e "\033[31m반드시 채점기준표를 참고하면서 실행하십시오!\033[0m"

echo -e "4. S3 hosting에서 설정한 wsi-<비번호>-<4자리 임의 영문>-web-static 형식의 버킷 이름을 입력하십시오..."
read web_static_bucket_name

echo -e "6. 웹 어플리케이션에서 설정한 wsi-<비번호>-<4자리 임의 영문>-artifactory 형식의 버킷 이름을 입력하십시오..."
read artifactory_bucket_name

echo -e "\"WEB STATIC\" : \033[33m$web_static_bucket_name\033[0m"
echo -e "\"ARTIFACTORY\" : \033[33m$artifactory_bucket_name\033[0m"

echo -e "=====CHECK IDENTITY====="
aws sts get-caller-identity
echo -e "콘솔에서 선수가 지급받은 계정과 동일한지 확인하십시오."
echo -e "========================"

echo -e "1-1 ~ 1-4 채점을 시작합니다... (엔터를 누르십시오.)"
read

echo -e "==========1-1==========="
result_1_1_2=`aws ec2 describe-vpcs --filter Name=tag:Name,Values=wsi-vpc --query "Vpcs[].CidrBlock"`
echo -e $result_1_1_2
if [[ "$result_1_1_2" =~ "10.1.0.0/16" ]]; then
    echo -e "\033[102m정답입니다! (1.5)\033[0m"
else
    echo -e "\033[101m오답입니다!\033[0m"
fi
echo -e "========================"

echo -e "==========1-2==========="
result_1_2_2=`aws ec2 describe-subnets --filter Name=tag:Name,Values=wsi-public-a --query "Subnets[].CidrBlock"`
echo -e $result_1_2_2
if [[ "$result_1_2_2" =~ "10.1.2.0/24" ]]; then
    echo -e "\033[102m정답입니다! (1.0)\033[0m"
else
    echo -e "\033[101m오답입니다!\033[0m"
fi

result_1_2_3=`aws ec2 describe-subnets --filter Name=tag:Name,Values=wsi-private-a --query "Subnets[].CidrBlock"`
echo -e $result_1_2_3
if [[ "$result_1_2_3" =~ "10.1.0.0/24" ]]; then
    echo -e "\033[102m정답입니다! (1.0)\033[0m"
else
    echo -e "\033[101m오답입니다!\033[0m"
fi
echo -e "========================"

echo -e "==========1-3==========="
result_1_3_2=`aws ec2 describe-subnets --filter Name=tag:Name,Values=wsi-public-a --query "Subnets[].AvailabilityZone"`
echo -e $result_1_3_2
if [[ "$result_1_3_2" =~ "ap-northeast-2a" ]]; then
    echo -e "\033[102m정답입니다! (1.0)\033[0m"
else
    echo -e "\033[101m오답입니다!\033[0m"
fi

result_1_3_3=`aws ec2 describe-subnets --filter Name=tag:Name,Values=wsi-private-b --query "Subnets[].AvailabilityZone"`
echo -e $result_1_3_3
if [[ "$result_1_3_3" =~ "ap-northeast-2b" ]]; then
    echo -e "\033[102m정답입니다! (1.0)\033[0m"
else
    echo -e "\033[101m오답입니다!\033[0m"
fi
echo -e "========================"

echo -e "==========1-4==========="
result_1_4_2=`aws ec2 describe-route-tables --filter Name=tag:Name,Values=wsi-private-a-rt --query "RouteTables[].Routes[].NatGatewayId"`
echo -e $result_1_4_2
if [[ "$result_1_4_2" =~ "nat-" ]]; then
    echo -e "\033[102m정답입니다! (1.0)\033[0m"
else
    echo -e "\033[101m오답입니다!\033[0m"
fi

result_1_4_4=`aws ec2 describe-route-tables --filter Name=tag:Name,Values=wsi-private-b-rt --query "RouteTables[].Routes[].NatGatewayId"`
echo -e $result_1_4_4
if [[ "$result_1_4_4" =~ "nat-" && $result_1_4_2 -ne $result_1_4_4 ]]; then
    echo -e "\033[102m정답입니다! (1.0)\033[0m"
else
    echo -e "\033[101m오답입니다!\033[0m"
fi

result_1_4_6=`aws ec2 describe-route-tables --filter Name=tag:Name,Values=wsi-public-rt --query "RouteTables[].Routes[].GatewayId"`
echo -e $result_1_4_6
if [[ "$result_1_4_6" =~ "igw-" ]]; then
    echo -e "\033[102m정답입니다! (1.0)\033[0m"
else
    echo -e "\033[101m오답입니다!\033[0m"
fi
echo -e "========================"

echo -e "2-1 ~ 2-3 채점을 시작합니다... (엔터를 누르십시오.)"
read

echo -e "==========2-1==========="
result_2_1_2=`aws s3 ls $web_static_bucket_name`
echo -e $result_2_1_2
if [[ "$result_2_1_2" =~ "1476 index.html" ]]; then
    echo -e "\033[102m정답입니다! (1.0)\033[0m"
else
    echo -e "\033[101m오답입니다!\033[0m"
fi
echo -e "========================"

echo -e "==========2-2==========="
result_2_2_2=`aws s3 ls $artifactory_bucket_name`
echo -e $result_2_2_2
if [[ "$result_2_2_2" =~ "1043 app.py" ]]; then
    echo -e "\033[102m정답입니다! (1.0)\033[0m"
else
    echo -e "\033[101m오답입니다!\033[0m"
fi
echo -e "========================"

echo -e "==========2-3==========="
aws ec2 describe-instances --filter Name=tag:Name,Values=wsi-web-api-asg --query "Reservations[].Instances[].PrivateIpAddress"
echo -e "위 IP 중 하나를 사용해 SSH로 접근한 후, 아래의 명령어를 차례로 입력하십시오. 채점기준표를 참고하십시오."
echo -e "mkdir /opt/tmp/"
echo -e "aws s3 cp s3://$artifactory_bucket_name/app.py /opt/tmp/app-zxzc39"
echo -e "ls /opt/tmp/app-zxzc39"
echo -e "echo \"hellow cloud\" > /opt/app-yzkz-39.txt"
echo -e "aws s3 cp /opt/app-yzkz-39.txt s3://$artifactory_bucket_name/"
echo -e "========================"

echo -e "3-1 ~ 3-2 채점을 시작합니다... (엔터를 누르십시오.)"
read

echo -e "==========3-1==========="
result_3_1_2=`aws ec2 describe-instances --filter Name=tag:Name,Values=wsi-bastion-ec2 --query 'Reservations[].Instances[].InstanceId'`
echo -e $result_3_1_2
if [[ "$result_3_1_2" =~ "i-" ]]; then
    echo -e "\033[102m정답입니다! (0.7)\033[0m"
else
    echo -e "\033[101m오답입니다!\033[0m"
fi
echo -e "========================"

echo -e "==========3-2==========="
result_3_2_2=`aws ec2 describe-instances --filter Name=tag:Name,Values=wsi-bastion-ec2 --query "Reservations[].Instances[].PublicIpAddress" --output text`
result_3_2_3=`aws ec2 describe-addresses --query "Addresses[].PublicIp"`
echo -e $result_3_2_2
echo -e $result_3_2_3
if [[ "$result_3_2_3" =~ $result_3_2_2 ]]; then
    echo -e "\033[102m정답입니다! (0.9)\033[0m"
else
    echo -e "\033[101m오답입니다!\033[0m"
fi
echo -e "========================"

echo -e "4-1 ~ 4-4 채점을 시작합니다... (엔터를 누르십시오.)"
read

echo -e "==========4-1==========="
result_4_1_2=`aws cloudfront list-distributions --query "DistributionList.Items[].Id | [0]"`
echo -e $result_4_1_2
if [[ "$result_4_1_2" =~ ^\"[A-Za-z0-9]{14}\"$ ]]; then
    echo -e "\033[102m정답입니다! (0.9)\033[0m"
else
    echo -e "\033[101m오답입니다!\033[0m"
fi
echo -e "========================"

echo -e "==========4-2==========="
result_4_2_2=`aws cloudfront list-distributions --query "DistributionList.Items[].Origins.Items[]" | jq ".[].DomainName" | grep s3`
echo -e $result_4_2_2
if [[ "$result_4_2_2" =~ $web_static_bucket_name ]]; then
    echo -e "\033[102m정답입니다! (1.5)\033[0m"
else
    echo -e "\033[101m오답입니다!\033[0m"
fi
echo -e "========================"

echo -e "==========4-3==========="
result_4_3_2=`aws cloudfront list-distributions --query "DistributionList.Items[].Origins.Items[]" | jq ".[].DomainName" | grep elb`
echo -e $result_4_3_2
if [[ "$result_4_3_2" =~ "wsi-web-api-alb" ]]; then
    echo -e "\033[102m정답입니다! (1.5)\033[0m"
else
    echo -e "\033[101m오답입니다!\033[0m"
fi
echo -e "========================"

echo -e "==========4-4==========="
result_4_4_2=`aws cloudfront list-distributions --query "DistributionList.Items[].Id | [0]"`
result_4_4_3=`aws cloudfront get-distribution-config --id ${result_4_4_2:1:14} --query "DistributionConfig.PriceClass"`
echo -e result_4_4_2
echo -e result_4_4_3
if [[ "result_4_4_3" =~ "PriceClass_All" ]]; then
    echo -e "\033[102m정답입니다! (1.1)\033[0m"
else
    echo -e "\033[101m오답입니다!\033[0m"
fi
echo -e "========================"

echo -e "5-1 ~ 5-3 채점을 시작합니다... (엔터를 누르십시오.)"
read

echo -e "==========5-1==========="
result_5_1_2=`aws cloudfront list-distributions --query "DistributionList.Items[].DomainName | [0]"`
echo -e "크롬 웹브라우저 창을 열고 아래의 URL에 접속하십시오."
echo -e ${result_5_1_2:1:-1}"/index.html"
echo -e "========================"

echo -e "==========5-2==========="
echo -e "5-1의 웹페이지에서 color name에 \"\033[36mred\033[0m\", hash에 \"\033[36mab12\033[0m\"를 입력하고 submit 버튼을 누르십시오."
echo -e "\033[32m{\"code\":\"f34a07\",\"name\":\"orange\"}\033[0m 인지 확인합니다."
echo -e "========================"

echo -e "==========5-3==========="
echo -e "5-1의 웹페이지에서 color name에 \"\033[36mdiamond\033[0m\", hash에 \"\033[36maaaa\033[0m\"를 입력하고 submit 버튼을 누르십시오."
echo -e "\033[32m{\"code\":\"ff00ff\",\"name\":\"pink\"}\033[0m 인지 확인합니다."
echo -e "========================"

echo -e "6-1 ~ 6-3 채점을 시작합니다... (엔터를 누르십시오.)"
read

echo -e "==========6-1==========="
result_6_1_2=`aws elbv2 describe-load-balancers --names "wsi-web-api-alb" --query "LoadBalancers[].Scheme"`
result_6_1_3=`aws elbv2 describe-load-balancers --names "wsi-web-api-alb" --query "LoadBalancers[].Type"`
echo -e $result_6_1_2
echo -e $result_6_1_3
if [[ "$result_6_1_2" =~ "internet-facing" && "$result_6_1_3" =~ "application" ]]; then
    echo -e "\033[102m정답입니다! (0.9)\033[0m"
else
    echo -e "\033[101m오답입니다!\033[0m"
fi
echo -e "========================"

# TODO: Start from here

echo -e "==========6-2==========="
aws elbv2 describe-load-balancers --names "wsi-web-api-alb" --query "LoadBalancers[].DNSName"
echo "Please enter this domain to a bastion server using curl..."
echo -e "========================"

echo -e "==========6-3==========="
aws ec2 describe-instances --filter Name=tag:Name,Values=wsi-web-api-asg --query "Reservations[].Instances[].PrivateIpAddress"
echo "Please enter this domain to a bastion server using timeout..."
echo -e "========================"

echo "Continue 7-1...?"
read

echo -e "==========7-1==========="
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names wsi-web-api-asg --query "AutoScalingGroups[].Instances[].HealthStatus"
echo -e "========================"

echo -e "==========7-2==========="
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names wsi-web-api-asg --query "AutoScalingGroups[].AvailabilityZones"
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names wsi-web-api-asg --query "AutoScalingGroups[].MinSize"
echo -e "========================"

echo -e "==========7-3==========="
aws autoscaling describe-policies --auto-scaling-group-name wsi-web-api-asg --query "ScalingPolicies[].AutoScalingGroupName"
echo -e "========================"

echo -e "==========7-4==========="
aws autoscaling update-auto-scaling-group --auto-scaling-group-name wsi-web-api-asg --min-size 2 --max-size 5 --desired-capacity 2
for (( ; ; ))
do
    aws ec2 describe-instances --filter Name=tag:Name,Values=wsi-web-api-asg --query "Reservations[].Instances[].PrivateIpAddress"
    echo "Are there only two instances? (Y/n)"
    read tmp_1

    if [ $tmp_1 -eq "Y" -o $tmp_1 -eq "y" ]; then
        break
    fi
done
echo ""
echo "Please enter these commands on player's ec2 server..."
echo "sudo amazon-linux-extras install -y epel; sudo yum install -y stress"
echo "stress -c 2"
echo ""
echo "Please open a new bastion server terminal and enter this command..."
echo "aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names wsi-web-api-asg --query \"AutoScalingGroups[].DesiredCapacity\""
echo -e "========================"

echo "Continue 7-5...?"
read

echo -e "==========7-5==========="
aws autoscaling update-auto-scaling-group --auto-scaling-group-name wsi-web-api-asg --min-size 0 --max-size 0 --desired-capacity 0
for (( ; ; ))
do
    aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names wsi-web-api-asg --query "AutoScalingGroups[].Instances[].InstanceId"
    echo "Is it empty? (Y/n)"
    read tmp_2

    if [ $tmp_2 -eq "Y" -o $tmp_2 -eq "y" ]; then
        break
    fi
done
aws autoscaling update-auto-scaling-group --auto-scaling-group-name wsi-web-api-asg --min-size 1 --max-size 1 --desired-capacity 1
aws elbv2 describe-load-balancers --names "wsi-web-api-alb" --query "LoadBalancers[].DNSName"
echo "Please enter this domain to a bastion server using curl in 7 minutes..."
echo -e "========================"

echo "Continue 8-1...?"
read

echo -e "==========8-1==========="
aws logs describe-log-groups --log-group-name-prefix /aws/ec2/wsi --query "logGroups[].storedBytes"
echo -e "========================"

echo -e "==========8-2==========="
aws elbv2 describe-load-balancers --names "wsi-web-api-alb" --query "LoadBalancers[].DNSName"
echo -e "Please enter this domain to a bastion server using \"\033[31mcurl http://< ELB DNS >/v1/color\?name\=blue\&hash\=999wsi2021abcd\033[0m\"..."
for (( ; ; ))
do
    aws logs tail '/aws/ec2/wsi' --since 5m | grep 999wsi2021abcd
    echo "Is it exists? You can wait 3 minutes. (Y/n)"
    read tmp_2

    if [ $tmp_2 -eq "Y" -o $tmp_2 -eq "y" ]; then
        break
    fi
done
echo -e "========================"

echo -e "==========8-3==========="
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names wsi-web-api-asg --query "AutoScalingGroups[].Instances[].InstanceId"
aws logs describe-log-streams --log-group-name '/aws/ec2/wsi' --query "logStreams[].logStreamName"
echo -e "========================"

echo "Continue 9-1...?"
read

echo -e "==========9-1==========="
echo "Please check cloudwatch dashboard"
echo -e "========================"

echo "Continue 9-2...?"
read

echo -e "==========9-2==========="
aws elbv2 describe-load-balancers --names "wsi-web-api-alb" --query "LoadBalancers[].DNSName"
echo -e "Please enter this domain to a bastion server using \"\033[31mwhile true; do curl --silent http://< ELB DNS >/v1/color > /dev/null; done\033[0m\"..."
echo -e "========================"

echo "Continue 9-3...?"
read

echo -e "==========9-3==========="
aws autoscaling update-auto-scaling-group --auto-scaling-group-name wsi-web-api-asg --min-size 1 --max-size 1 --desired-capacity 1
for (( ; ; ))
do
    aws ec2 describe-instances --filter Name=tag:Name,Values=wsi-web-api-asg --query "Reservations[].Instances[].PrivateIpAddress"
    echo "Are there only one instance? (Y/n)"
    read tmp_1

    if [ $tmp_1 -eq "Y" -o $tmp_1 -eq "y" ]; then
        break
    fi
done
echo ""
echo "Please enter these commands on player's ec2 server..."
echo "sudo amazon-linux-extras install -y epel; sudo yum install -y stress"
echo "stress -c 2"
echo -e "========================"
