<#import "components.ftl" as components>
<#if message?has_content>
    <#assign messageParts = message.summary?split("||")>
    
    <#if (messageParts?size > 1)>
        <#assign messageKey = msg(messageParts[0])>
        <#assign messageValue = messageParts[1]>
    <#else>
        <#assign messageKey = msg("errorTitle")>
        <#assign messageValue = message.summary>
    </#if>
</#if>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accedi - Portale Punto Vendita</title>
    <link href="${url.resourcesPath}/${properties.styles}" rel="stylesheet">
</head>
<body>
    <div class="page-container">
        <@components.header />

        <main class="main-content">
            <div class="error-page-wrapper">
                <div class="info-icon-wrapper">
                    <svg height="25px" viewBox="0 -960 960 960" width="25px" fill="#0b3ee3"><path d="M479.79-144Q450-144 429-165.21t-21-51Q408-246 429.21-267t51-21Q510-288 531-266.79t21 51Q552-186 530.79-165t-51 21Zm0-240Q450-384 429-405.17q-21-21.16-21-50.89v-288.22Q408-774 429.21-795t51-21Q510-816 531-794.83q21 21.16 21 50.89v288.22Q552-426 530.79-405t-51 21Z"/></svg>
                </div>
                <#if message?has_content>
                    <h1>${kcSanitize(messageKey)?no_esc}</h1>
                    <p class="instruction">${kcSanitize(messageValue)?no_esc}</p>
                </#if>
            </div>
        </main>

        <@components.footer />
    </div>
    </body>
</html>
