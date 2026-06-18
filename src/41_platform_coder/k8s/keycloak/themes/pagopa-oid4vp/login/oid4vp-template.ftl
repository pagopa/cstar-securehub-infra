<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true>
<!DOCTYPE html>
<html class="${properties.kcHtmlClass!}" lang="${lang}">
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="color-scheme" content="light">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${msg("loginTitle",(realm.displayName!''))}</title>
    <#if properties.stylesCommon?has_content>
        <#list properties.stylesCommon?split(' ') as style>
            <link href="${url.resourcesCommonPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
</head>
<body class="${properties.kcBodyClass!} pagopa-oid4vp-body">
<div class="oid4vp-page">
    <header class="oid4vp-header">
        <a class="oid4vp-header__brand"
           href="https://www.pagopa.it"
           aria-label="Vai al sito PagoPA S.p.A.">
            PagoPA S.p.A.
        </a>
    </header>

    <main class="oid4vp-main">
        <section class="oid4vp-card" aria-labelledby="kc-page-title">
            <div class="oid4vp-card__header">
                <h1 class="oid4vp-card__title" id="kc-page-title"><#nested "header"></h1>
                <#if (sameDeviceEnabled!false) && (sameDeviceWalletUrl!'')?has_content>
                    <a class="oid4vp-refresh-button oid4vp-open-wallet-button"
                       href="${sameDeviceWalletUrl!''}">
                        Apri l'app
                    </a>
                    <p class="oid4vp-card__separator">oppure</p>
                </#if>
                <p class="oid4vp-card__description">
                    Usa la sezione &lsquo;Inquadra&rsquo; di app <strong>IO - l'app dei servizi pubblici</strong>, oppure la fotocamera del tuo dispositivo, per scansionare il QR Code e accedere ai servizi.
                </p>
            </div>

            <div class="oid4vp-card__body">
                <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                    <div class="oid4vp-alert oid4vp-alert--${(message.type = 'error')?then('danger', message.type)}">
                        <span class="kc-feedback-text">${message.summary}</span>
                    </div>
                </#if>
                <#nested "form">
            </div>
        </section>
    </main>
</div>
</body>
</html>
</#macro>
