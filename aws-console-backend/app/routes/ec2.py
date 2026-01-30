import boto3
from fastapi import APIRouter, HTTPException

ec2_router = APIRouter(
    prefix="/ec2",
    tags=["EC2"]
)

ec2 = boto3.client("ec2", region_name="us-east-1")

@ec2_router.post("/launch")
def launch_instance():
    try:
        response = ec2.run_instances(
            ImageId="ami-0532be01f26a3de55",
            InstanceType="t2.micro",
            KeyName="mac",
            SubnetId="subnet-022d36f56e3da44e6",
            SecurityGroupIds=["sg-0119dbbe0842f33fa"],
            MinCount=1,
            MaxCount=1
        )

        instance_id = response["Instances"][0]["InstanceId"]

        return {
            "message": "Instance EC2 lancée",
            "instance_id": instance_id
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))