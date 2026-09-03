<#if actionUri?has_content && requiredActions?? && requiredActions?size == 1 && requiredActions?seq_contains("UPDATE_PASSWORD")>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${msg("updatePasswordTitle")}</title>
    <link href="${url.resourcesPath}/${properties.styles}" rel="stylesheet">
</head>
<body>
    <div class="page-container">
        <header class="header">
            <div class="header-logo">
                <p class="text-dark">PagoPA S.p.A.</p>
            </div>
            <nav class="header-nav">
                <a href="https://developer.pagopa.it/pari/guides/bonuselettrodomestici-manuale-tecnico-venditore" class="text-dark-light">
                    <img alt="" src="${url.resourcesPath}/img/book.png"/>
                    Manuale operativo
                </a>
                <a href="https://developer.pagopa.it/pari/guides/bonuselettrodomestici-manuale-tecnico-venditore/contatti" class="text-dark-light">
                    <img alt="" src="${url.resourcesPath}/img/info.png"/>
                    Assistenza
                </a>
            </nav>
        </header>

        <main class="main-content execute-actions-content">
            <div class="execute-actions-status" data-execute-actions-auto-redirect data-redirect-delay="800">
                <div class="execute-actions-loader" aria-hidden="true"></div>
                <h1>Attendi qualche secondo</h1>
                <p>
                    Se non vieni reindirizzato automaticamente,
                    <a href="${actionUri}" data-execute-actions-target>clicca qui</a>.
                </p>
            </div>
        </main>

        <#include "footer.ftl">
    </div>
    <script type="module" src="${url.resourcesPath}/js/execute-actions-auto-redirect.js?v=themeVersion"></script>
</body>
</html>
<#else>
    <#import "template.ftl" as layout>
    <@layout.registrationLayout displayMessage=false; section>
        <#if section = "header">
            <#if messageHeader??>
                ${kcSanitize(msg("${messageHeader}"))?no_esc}
            <#else>
                ${message.summary}
            </#if>
        <#elseif section = "form">
        <div id="kc-info-message">
            <p class="instruction">${message.summary}<#if requiredActions??><#list requiredActions>: <b><#items as reqActionItem>${kcSanitize(msg("requiredAction.${reqActionItem}"))?no_esc}<#sep>, </#items></b></#list><#else></#if></p>
            <#if skipLink??>
            <#else>
                <#if pageRedirectUri?has_content>
                    <p><a href="${pageRedirectUri}">${msg("backToApplication")}</a></p>
                <#elseif actionUri?has_content>
                    <p><a href="${actionUri}">${msg("proceedWithAction")}</a></p>
                <#elseif (client.baseUrl)?has_content>
                    <p><a href="${client.baseUrl}">${msg("backToApplication")}</a></p>
                </#if>
            </#if>
        </div>
        </#if>
    </@layout.registrationLayout>
</#if>
