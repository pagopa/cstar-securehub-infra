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

ha:
  enabled: ${high_availability}
  storageClass: ${storage_class}
  accessMode: ${access_mode}
  size: ${storage_size}

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
