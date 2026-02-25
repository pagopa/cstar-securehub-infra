{
  "enabled": true,
  "realm": "master",
  "clients": [
    {
      "clientId": "terraform",
      "name": "Terraform (Managed by config-cli)",
      "enabled": true,
      "publicClient": false,
      "protocol": "openid-connect",
      "serviceAccountsEnabled": true,
      "secret": "${keycloak_terraform_client_secret}",
      "redirectUris": [
        "/*"
      ],
      "webOrigins": [
        "/*"
      ]
    }
  ],
  "users": [
    {
      "username": "service-account-terraform",
      "enabled": true,
      "serviceAccountClientId": "terraform",
      "realmRoles": [
        "create-realm"
      ],
      "clientRoles": {
        "master-realm": [
          "manage-realm"
        ],
        "user-realm": [
          "manage-realm",
          "query-clients",
          "create-client",
          "view-users",
          "view-authorization",
          "view-realm",
          "query-users",
          "manage-events",
          "query-realms",
          "view-events",
          "manage-users",
          "manage-clients",
          "view-identity-providers",
          "manage-identity-providers",
          "query-groups",
          "manage-authorization",
          "view-clients"
        ],
        "merchant-operator-realm": [
          "manage-identity-providers",
          "manage-authorization",
          "view-events",
          "view-identity-providers",
          "manage-clients",
          "create-client",
          "manage-events",
          "view-realm",
          "manage-users",
          "query-clients",
          "query-users",
          "query-groups",
          "manage-realm",
          "view-users",
          "view-clients",
          "view-authorization",
          "query-realms"
        ]
      }
    }
  ]
}
