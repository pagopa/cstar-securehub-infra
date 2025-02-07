image:
  repository: ${image_repository}
  tag: ${image_tag}

resources:
  limits:
    memory: ${resources_memory}
  requests:
    memory: ${resources_memory}

management_console:
  enabled: ${management_console_enabled}

replicaCount: ${replica_count}

persistence:
  enabled: ${persistence}
  storageClassName: ${storage_class}
  accessModes:
    - ${access_mode}
  storageSize: ${storage_size}

ha:
  enabled: ${high_availability}

affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: node_type
          operator: In
          values:
          - user
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      podAffinityTerm:
        labelSelector:
          matchLabels:
            app.kubernetes.io/instance: ${instance_name}
        namespaces: [${namespace}]
        topologyKey: topology.kubernetes.io/zone

podSecurityContext:
  fsGroup: 1001
