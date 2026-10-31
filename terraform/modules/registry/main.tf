resource "aws_ecr_repository" "backend_registry" {
  name = "m-motors-api"
  # Prevent image tag overwrites and ensure a distinct tag per version
  image_tag_mutability = "IMMUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name = "m-motors-api"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

}

# Keep only the last 10 images in the repository
resource "aws_ecr_lifecycle_policy" "backend_retention" {
  repository = aws_ecr_repository.backend_registry.name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep only the last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]

  })

}

