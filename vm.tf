resource "aws_security_group" "salmansg" {
    vpc_id= aws_vpc.salmanvpc.id
    name= "salmansg"


    #allow ssh port
    ingress {
        from_port= 22
        protocol= "tcp" 
        to_port= 22
        cidr_blocks= ["0.0.0.0/0"]
    }

    egress {
        from_port= 0
        to_port= 0
        protocol= "-1"
        cidr_blocks= ["0.0.0.0/0"]
    }
}

resource "aws_instance" "proja" {

    ami= "ami-0d70546e43a941d70"
    instance_type= "t2.micro"
    subnet_id= aws_subnet.salmanpub.id
    associate_public_ip_address= false
    key_name= "salman"
    vpc_security_group_ids= [aws_security_group.salmansg.id]
    root_block_device {
        delete_on_termination= true
        volume_type= "gp2"
    }
    tags= {
        name= "dev01"
        env= "dev"
        os= "ubuntu"
    }
}