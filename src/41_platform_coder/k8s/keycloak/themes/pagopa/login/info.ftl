<#if actionUri?has_content && requiredActions?? && requiredActions?seq_contains("UPDATE_PASSWORD")>
<!doctype html>
<html lang="${lang!'it'}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${msg("updatePasswordTitle")}</title>
    <link href="${url.resourcesPath}/${properties.styles}" rel="stylesheet">
</head>
<body class="execute-actions-redirect-page">
    <main
        data-execute-actions-auto-redirect
        data-redirect-delay="800"
        role="status"
        aria-label="${msg("updatePasswordTitle")}"
    >
        <div class="execute-actions-loader" aria-hidden="true"></div>
        <a href="${actionUri}" data-execute-actions-target hidden></a>
    </main>
    <script
        type="module"
        src="${url.resourcesPath}/js/execute-actions-auto-redirect.js?v=themeVersion"
    ></script>
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
