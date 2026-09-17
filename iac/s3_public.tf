# 1. S3 Bucket Public Read Access
resource "aws_s3_bucket" "finding_1" {
  bucket = "public-bucket-test"
  acl    = "public-read"
}

# 2. S3 Bucket Missing Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "finding_2" {
  bucket = aws_s3_bucket.finding_1.id
  # Encryption configuration omitted on purpose
}

# 3. Security Group with Open SSH (0.0.0.0/0)
resource "aws_security_group" "finding_3" {
  name = "open-ssh-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4. Security Group with Open RDP (0.0.0.0/0)
resource "aws_security_group" "finding_4" {
  name = "open-rdp-sg"
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 5. RDS Instance Unencrypted Storage
resource "aws_db_instance" "finding_5" {
  allocated_storage   = 20
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  storage_encrypted   = false
}

# 6. RDS Instance Publicly Accessible
resource "aws_db_instance" "finding_6" {
  allocated_storage   = 20
  engine              = "postgres"
  instance_class      = "db.t3.micro"
  publicly_accessible = true
}

# 7. Unencrypted EBS Volume
resource "aws_ebs_volume" "finding_7" {
  availability_zone = "us-east-1a"
  size              = 40
  encrypted         = false
}

# 8. CloudTrail Disabled Log File Validation
resource "aws_cloudtrail" "finding_8" {
  name                          = "insecure-trail"
  s3_bucket_name                = "some-bucket"
  enable_log_file_validation    = false
}

# 9. EFS File System Unencrypted
resource "aws_efs_file_system" "finding_9" {
  creation_token = "my-efs"
  encrypted      = false
}

# 10. IAM Policy with Wildcard (*) Admin Privileges
resource "aws_iam_policy" "finding_10" {
  name = "overprivileged_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "*"
      Resource = "*"
    }]
  })
}
