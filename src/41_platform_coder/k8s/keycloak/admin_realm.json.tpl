{
  "realm": "master_terraform",
  "enabled": true,
  "users": [
    {
      "username": "${keycloak_admin_username}",
      "enabled": true,
      "emailVerified": true,
      "email": "admin@example.com",
      "firstName": "Admin",
      "lastName": "Permanent",
      "credentials": [
        {
          "type": "password",
          "value": "${keycloak_admin_password}",
          "temporary": false
        }
      ],
      "requiredActions": [],
      "realmRoles": ["admin"]
    }
  ],
  "roles": {
    "realm": [
      { "name": "admin" }
    ]
  }
}
