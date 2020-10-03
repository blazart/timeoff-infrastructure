resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity = var.max_capacity
  min_capacity = var.min_capacity
  resource_id = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.main.name}}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
  depends_on = [
    aws_ecs_service.main
  ]
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name = "memory-autoscaling"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 80
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name = "cpu-autoscaling"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}


