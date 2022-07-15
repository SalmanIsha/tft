provider "aws" {
    region= "us-west-2"
    profile= "vscode"
}

#Create the VPC

resource "aws_vpc" "salmanvpc" {
    cidr_block=     "10.0.0.0/24"
    instance_tenancy= "default"

}

#Create internet gateway and attach to vpc

resource "aws_internet_gateway" "salmanigw" {
    vpc_id= aws_vpc.salmanvpc.id
}

resource "aws_subnet" "salmanpub" {
    vpc_id= aws_vpc.salmanvpc.id
    cidr_block= "10.0.0.128/26"
}

resource "aws_subnet" "salmanpvt" {
    vpc_id= aws_vpc.salmanvpc.id
    cidr_block= "10.0.0.192/26"
}

resource "aws_eip" "nateip" {
    vpc= true
}

resource "aws_nat_gateway" "salmanngw" {
    allocation_id= aws_eip.nateip.id
    subnet_id= aws_subnet.salmanpvt.id
}

# create public route table
resource "aws_route_table" "pubrt" {
    vpc_id= aws_vpc.salmanvpc.id
    route {
        cidr_block= "0.0.0.0/0"
        gateway_id= aws_internet_gateway.salmanigw.id
    }
}

#create private route table

resource "aws_route_table" "pvtrt" {
    vpc_id= aws_vpc.salmanvpc.id
    route {
        cidr_block= "0.0.0.0/0"
        nat_gateway_id= aws_nat_gateway.salmanngw.id
    }
}


# route table association with pubsubnet

resource "aws_route_table_association" "pubrtassc" {
    subnet_id= aws_subnet.salmanpub.id
    route_table_id= aws_route_table.pubrt.id
}

resource "aws_route_table_association" "pvtrtassc" {
    subnet_id= aws_subnet.salmanpvt.id
    route_table_id= aws_route_table.pvtrt.id
}