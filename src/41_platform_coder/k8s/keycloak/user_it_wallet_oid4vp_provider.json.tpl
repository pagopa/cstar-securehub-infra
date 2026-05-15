{
  "realm": "${realm_name}",
  "identityProviders": [
    {
      "alias": "${alias}",
      "displayName": "${display_name}",
      "providerId": "oid4vp",
      "enabled": true,
      "config": {
        "clientIdScheme": "${client_id_scheme}",
        "responseMode": "${response_mode}",
        "sameDeviceEnabled": "${same_device_enabled}",
        "crossDeviceEnabled": "${cross_device_enabled}",
        "walletScheme": "${wallet_scheme}",
        "enforceHaip": "${enforce_haip}",
        "credentialSetMode": "${credential_set_mode}",
        "credentialSetPurpose": ${credential_set_purpose_json},
        "dcqlQuery": ${dcql_query_json},
        "userMappingClaim": "${user_mapping_claim}",
        "userMappingClaimMdoc": "${user_mapping_claim_mdoc}",
        "x509CertificatePem": ${x509_certificate_pem_json},
        "verifierInfo": ${verifier_info_json},
        "trustListUrl": ${trust_list_url_json},
        "trustListLoTEType": ${trust_list_lote_type_json},
        "trustedAuthoritiesMode": "${trusted_authorities_mode}",
        "trustListSigningCertPem": ${trust_list_signing_cert_pem_json},
        "allowedIssuers": "${allowed_issuers}"
        "client_metadata" "${client_metadata_json}"
      }
    }
  ],
  "identityProviderMappers": [
    {
      "name": "${alias}-first-name",
      "identityProviderAlias": "${alias}",
      "identityProviderMapper": "oid4vp-user-attribute-mapper",
      "config": {
        "syncMode": "INHERIT",
        "credential.format": "${credential_format}",
        "credential.type": "${credential_type}",
        "claim": "${first_name_claim}",
        "user.attribute": "firstName",
        "multivalued": "false",
        "optional": "false"
      }
    },
    {
      "name": "${alias}-last-name",
      "identityProviderAlias": "${alias}",
      "identityProviderMapper": "oid4vp-user-attribute-mapper",
      "config": {
        "syncMode": "INHERIT",
        "credential.format": "${credential_format}",
        "credential.type": "${credential_type}",
        "claim": "${last_name_claim}",
        "user.attribute": "lastName",
        "multivalued": "false",
        "optional": "false"
      }
    },
    {
      "name": "${alias}-username",
      "identityProviderAlias": "${alias}",
      "identityProviderMapper": "oid4vp-user-attribute-mapper",
      "config": {
        "syncMode": "INHERIT",
        "credential.format": "${credential_format}",
        "credential.type": "${credential_type}",
        "claim": "${username_claim}",
        "user.attribute": "username",
        "multivalued": "false",
        "optional": "false"
      }
    },
    {
      "name": "${alias}-fiscal-number",
      "identityProviderAlias": "${alias}",
      "identityProviderMapper": "oid4vp-user-attribute-mapper",
      "config": {
        "syncMode": "INHERIT",
        "credential.format": "${credential_format}",
        "credential.type": "${credential_type}",
        "claim": "${fiscal_number_claim}",
        "user.attribute": "fiscalNumber",
        "multivalued": "false",
        "optional": "false"
      }
    },
    {
      "name": "${alias}-date-of-birth",
      "identityProviderAlias": "${alias}",
      "identityProviderMapper": "oid4vp-user-attribute-mapper",
      "config": {
        "syncMode": "INHERIT",
        "credential.format": "${credential_format}",
        "credential.type": "${credential_type}",
        "claim": "${date_of_birth_claim}",
        "user.attribute": "dateOfBirth",
        "multivalued": "false",
        "optional": "false"
      }
    }
  ]
}
