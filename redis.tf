resource "aws_elasticache_subnet_group" "Subnet" {
  name = "subnet"

  subnet_ids = [
    aws_subnet.pub_sub1.id,
    aws_subnet.pub_sub2.id
  ]
}

resource "aws_elasticache_parameter_group" "default" {
  name   =  "default"
  family = "redis6.x"
  }

resource "aws_elasticache_cluster" "ryu" {
  cluster_id = "subnet"
  engine = "redis"
  node_type = "cache.t2.micro"
  port = 6379
  num_cache_nodes = 1
  parameter_group_name = "default"
  subnet_group_name = "${aws_elasticache_subnet_group.Subnet.name}"
}


