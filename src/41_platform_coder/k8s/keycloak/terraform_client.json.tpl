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
        "create-realm",
        "admin"
      ],
      "clientRoles": {}
    }
  ]
}
