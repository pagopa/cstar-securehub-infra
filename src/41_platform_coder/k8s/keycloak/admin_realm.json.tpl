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
    },
    {
      "id": "fbc705c8-e179-404b-921a-0f4ea34fd7c6",
      "username": "service-account-terraform",
      "emailVerified": false,
      "createdTimestamp": 1751978257063,
      "enabled": true,
      "totp": false,
      "serviceAccountClientId": "terraform",
      "disableableCredentialTypes": [],
      "requiredActions": [],
      "realmRoles": [
        "create-realm"
      ],
      "notBefore": 0,
      "groups": []
    }
  ],
  "roles": {
    "realm": [
      { "name": "admin" },
      {
        "id": "d5e499dd-579e-4f81-8d1e-8adb859d2d57",
        "name": "create-realm",
        "description": "role_create-realm",
        "composite": false,
        "clientRole": false,
        "containerId": "2a152c4f-b524-4338-8f83-e1caefc0a1f8",
        "attributes": {}
      }
    ]
  },
  "clients": [
    {
      "id": "c5842909-5d7f-4d8f-a80a-48f7b35aafe8",
      "clientId": "terraform",
      "name": "",
      "description": "",
      "rootUrl": "",
      "adminUrl": "",
      "baseUrl": "",
      "surrogateAuthRequired": false,
      "enabled": true,
      "alwaysDisplayInConsole": false,
      "clientAuthenticatorType": "client-secret",
      "secret": "${terraform_client_secret}",
      "redirectUris": [
        "/*"
      ],
      "webOrigins": [
        "/*"
      ],
      "notBefore": 0,
      "bearerOnly": false,
      "consentRequired": false,
      "standardFlowEnabled": true,
      "implicitFlowEnabled": false,
      "directAccessGrantsEnabled": false,
      "serviceAccountsEnabled": true,
      "publicClient": false,
      "frontchannelLogout": true,
      "protocol": "openid-connect",
      "attributes": {
        "realm_client": "false",
        "oidc.ciba.grant.enabled": "false",
        "client.secret.creation.time": "1751978257",
        "backchannel.logout.session.required": "true",
        "standard.token.exchange.enabled": "false",
        "oauth2.device.authorization.grant.enabled": "false",
        "backchannel.logout.revoke.offline.tokens": "false"
      },
      "authenticationFlowBindingOverrides": {},
      "fullScopeAllowed": true,
      "nodeReRegistrationTimeout": -1,
      "defaultClientScopes": [
        "web-origins",
        "service_account",
        "acr",
        "profile",
        "roles",
        "basic",
        "email"
      ],
      "optionalClientScopes": [
        "address",
        "phone",
        "offline_access",
        "organization",
        "microprofile-jwt"
      ]
    }
  ]
}
