read -p "want to give aws credentials?(Y/n)" cred
if [[ $cred == "Y" || $cred == "y" ]]; then
    aws configure
fi
#asking default region
read -p "Enter default region:" region

function costoptimization(){
    #deleting orphaned ec2 instance
    echo "-----------------------------------------"
    echo "finding the orphaned EC2 instances"
    read -p "Enter env value:" env
    EC2_ID=$( aws ec2 describe-instances \
    --region $region \
    --filters "Name=tag:Environment,Values=$env" "Name=instance-state-name,Values=running" \
    --query "Reservations[].Instances[].InstanceId" \
    --output text )

    if [[ -n "$EC2_ID" ]]; then
        for EC2 in $EC2_ID; do
        echo "deleting $EC2"
        aws ec2 terminate-instances --region "$region" --instance-ids "$EC2"
        done
    else
        echo "no orphaned instances found"
    fi

    #finding and deleting unattached ebs volumes
    echo "-----------------------------------------"
    echo "finding unattached ebs volumes"
    EBS_VOLUMES=$( aws ec2 describe-volumes \
    --region $region \
    --filters "Name=status,Values=available" \
    --query "Volumes[].VolumeId" \
    --output text )

    if [[ -n "$EBS_VOLUMES" ]]; then
        for VOLUME in $EBS_VOLUMES; do
        echo "deleting EBS volume id: $VOLUME"
        aws ec2 delete-volume --region "$region" --volume-id "$VOLUME"
        done
    else
        echo "No unattached ebs volumes found"
    fi

    #finding unassociated Elastic IPs
    echo "-----------------------------------------"
    ELASTIC_IPS=$( aws ec2 describe-addresses \
    --region $region \
    --query "Addresses[?AssociationId==null].AllocationId" \
    --output text )

    if [[ -n "$ELASTIC_IPS" ]]; then
        for E_IP in $ELASTIC_IPS; do
        echo "deleting unassociated elastic ips id: $E_IP"
        aws ec2 release-address --region "$region" --allocation-id "$E_IP"
        done
    else
        echo "no unassociated elastic ips found"
    fi

    #finding and deleting EBS snapshots
    echo "-----------------------------------------"
    read -p "want to delete old snapshots? (Y/n)" option

    if [[ $option == "Y" || $option == "y" ]]; then
        read -p "enter number of days to delete old snapshots" numberofdays

        RETENTION_DAYS=$(date -d "$numberofdays days ago" --utc +%Y-%m-%dT%H:%M:%SZ)
        OLD_SNAPSHOTS=$( aws ec2 describe-snapshots \
        --region $region \
        --owner-ids self \
        --query "Snapshots[?StartTime<='$RETENTION_DAYS'].SnapshotId" \
        --output text )

        if [[ -n "$OLD_SNAPSHOTS" ]]; then
            for SNAPSHOT in $OLD_SNAPSHOTS; do
            echo "Deleting snapshot id: $SNAPSHOT"
            aws ec2 delete-snapshot --region "$region" --snapshot-id "$SNAPSHOT"
            done
        else
            echo "no snapshots found"
    
        fi

    else
        echo "skipping snapshots"
        exit
    fi
}

costoptimization
