{
    "type": "metric",
    "x": 0,
    "y": 0,
    "width": 9,
    "height": 9,
    "properties": {
        "view": "singleValue",
        "stacked": true,
        "metrics": [
            [
                "AWS/ECS",
                "CPUUtilization",
                "ServiceName",
                "${service_name}",
                "ClusterName",
                "${cluster_name}",
                {
                    "label": "CPU Utilization",
                    "yAxis": "left"
                }
            ],
            [
                ".",
                "MemoryUtilization",
                ".",
                ".",
                ".",
                ".",
                {
                    "label": "Memory Utilization"
                }
            ],
            [
                "AWS/ApplicationELB",
                "RequestCount",
                "TargetGroup",
                "${target_group_arn_suffix}",
                "LoadBalancer",
                "${lb_arn_suffix}",
                {
                    "color": "#1f77b4",
                    "label": "Request Count"
                }
            ],
            [
                ".",
                "HealthyHostCount",
                ".",
                ".",
                ".",
                ".",
                {
                    "color": "#2ca02c",
                    "label": "Healthy Host Count"
                }
            ],
            [
                ".",
                "UnHealthyHostCount",
                ".",
                ".",
                ".",
                ".",
                {
                    "color": "#d62728",
                    "label": "Unhealthy Host Count"
                }
            ]
        ],
        "region": "${region}",
        "title": "${service_name}",
        "period": 300
    }
}
