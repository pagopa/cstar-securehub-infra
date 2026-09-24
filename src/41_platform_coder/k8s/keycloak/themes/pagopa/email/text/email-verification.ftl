<#ftl output_format="plainText">
${msg("emailGreetings")}
${msg("emailVerificationInput")}

${msg("emailVerificationInstructions1")} ${msg("emailVerificationInstructions2")}
${msg("emailVerificationInstructions3")}
${msg("emailVerificationLink")}
${link}

${msg("emailVerificationLinkInfo", linkExpirationFormatter(linkExpiration))}

${msg("emailHelp")} ${msg("emailMailTo")} ${msg("emailContact")}

${msg("emailRegards")}
${msg("emailRegardsFrom")}

${msg("emailCTA")}
${properties.baseURL}
