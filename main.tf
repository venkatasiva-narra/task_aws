provider "aws" {
    profile = "default"
    region = "us-west-2"
}


resource "aws_vpc" "task_vpc"{
    cidr_block = "190.160.0.0/16"
    instance_tenancy = "default"

    tags = {
        Name = "task_vpc"
    }
}


resource "aws_internet_gateway" "task_ig"{
    vpc_id = "${aws_vpc.task_vpc.id}"

    tags = {
        Name = "task_ig"
    }
}

resource "aws_subnet" "task_public_subnet_1"{
    vpc_id = "${aws_vpc.task_vpc.id}"
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-west-2a"

    tags = {
        Name = "task_public_subnet_1"
    }
}

resource "aws_subnet" "task_public_subnet_2"{
    vpc_id = "${aws_vpc.task_vpc.id}"
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-west-2b"

    tags = {
        Name = "task_public_subnet_2"
    }
}

resource "aws_subnet" "task_public_subnet_3"{
    vpc_id = "${aws_vpc.task_vpc.id}"
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-west-2c"

    tags = {
        Name = "task_public_subnet_3"
    }
}

resource "aws_subnet" "task_private_subnet_1"{
    vpc_id = "${aws_vpc.task_vpc.id}"
    cidr_block = "10.0.101.0/24"
    availability_zone = "us-west-2a"

    tags = {
        Name = "task_private_subnet_1"
    }
}

resource "aws_subnet" "task_private_subnet_2"{
    vpc_id = "${aws_vpc.task_vpc.id}"
    cidr_block = "10.0.102.0/24"
    availability_zone = "us-west-2b"

    tags = {
        Name = "task_private_subnet_2"
    }
}

resource "aws_subnet" "task_private_subnet_3"{
    vpc_id = "${aws_vpc.task_vpc.id}"
    cidr_block = "10.0.103.0/24"
    availability_zone = "us-west-2c"

    tags = {
        Name = "task_private_subnet_3"
    }
}

resource "aws_eip" "task_nat_1" {
    depends_on =[aws_internet_gateway.task_ig]
}

resource "aws_eip" "task_nat_2" {
    depends_on =[aws_internet_gateway.task_ig]
}

resource "aws_eip" "task_nat_3" {
    depends_on =[aws_internet_gateway.task_ig]
}

resource "aws_nat_gateway" "task_ng_1"{
    allocation_id = "${aws_eip.task_nat_1.id}"
    subnet_id = "${aws_subnet.task_public_subnet_1.id}"

    tags = {
        Name = "task_ng_1"
    }
}

resource "aws_nat_gateway" "task_ng_2"{
    allocation_id = "${aws_eip.task_nat_2.id}"
    subnet_id = "${aws_subnet.task_public_subnet_2.id}"

    tags = {
        Name = "task_ng_2"
    }
}

resource "aws_nat_gateway" "task_ng_3"{
    allocation_id = "${aws_eip.task_nat_3.id}"
    subnet_id = "${aws_subnet.task_public_subnet_3.id}"

    tags = {
        Name = "task_ng_3"
    }
}

resource "aws_route_table" "public_route" {
    vpc_id="${aws_vpc.task_vpc.id}"

    route {
        cidr_block ="0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.task_ig.id}"
    }
}


resource "aws_route_table" "private_route_1" {
    vpc_id="${aws_vpc.task_vpc.id}"

    route {
        cidr_block ="0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.task_ng_1.id}"
    }
}


resource "aws_route_table" "private_route_2" {
    vpc_id="${aws_vpc.task_vpc.id}"

    route {
        cidr_block ="0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.task_ng_2.id}"
    }
}


resource "aws_route_table" "private_route_3" {
    vpc_id="${aws_vpc.task_vpc.id}"

    route {
        cidr_block ="0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.task_ng_3.id}"
    }
}


resource "aws_route_table_association" "public_1"{
    subnet_id = "${aws_subnet.task_public_subnet_1.id}"
    route_table_id = "${aws_route_table.public_route.id}"
}

resource "aws_route_table_association" "public_2"{
    subnet_id = "${aws_subnet.task_public_subnet_2.id}"
    route_table_id = "${aws_route_table.public_route.id}"
}

resource "aws_route_table_association" "public_3"{
    subnet_id = "${aws_subnet.task_public_subnet_3.id}"
    route_table_id = "${aws_route_table.public_route.id}"
}

resource "aws_route_table_association" "private_1"{
    subnet_id = "${aws_subnet.task_private_subnet_1.id}"
    route_table_id = "${aws_route_table.private_route_1.id}"
}

resource "aws_route_table_association" "private_2"{
    subnet_id = "${aws_subnet.task_private_subnet_2.id}"
    route_table_id = "${aws_route_table.private_route_2.id}"
}

resource "aws_route_table_association" "private_3"{
    subnet_id = "${aws_subnet.task_private_subnet_3.id}"
    route_table_id = "${aws_route_table.private_route_3.id}"
}
