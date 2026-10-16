<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true cancelUrl="">
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

    <div class="oid4vp-subheader">
        <span class="oid4vp-subheader__icon" aria-hidden="true"></span>
        <span class="oid4vp-subheader__title">IT-Wallet</span>
    </div>

    <main class="oid4vp-main">
        <#if cancelUrl?has_content>
            <a class="oid4vp-back-link" href="${cancelUrl}">
                <svg width="18" height="14" viewBox="0 0 18 14" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" focusable="false">
                    <path d="M17.4 6.1H1.9L7.2 0.7L6.5 0L0 6.6L6.5 13.2L7.2 12.5L1.9 7.1H17.4V6.1Z" fill="currentColor"/>
                </svg>
                <span>Torna indietro</span>
            </a>
        </#if>
        <section class="oid4vp-card" aria-labelledby="kc-page-title">
            <div class="oid4vp-card__header">
                <h1 class="oid4vp-card__title" id="kc-page-title"><#nested "header"></h1>
                <p class="oid4vp-card__description">
                    Usa la funzionalit&agrave; di <strong>{IO, l&rsquo;app dei servizi pubblici}</strong><br>
                    o la <strong>fotocamera</strong> del tuo smartphone
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

    <footer class="oid4vp-footer">
        <div class="oid4vp-footer__top">
            <a class="oid4vp-footer__brand" href="https://www.pagopa.it/it/">
                <img src="${url.resourcesPath}/img/pagopa-logo.svg" alt="PagoPA" width="120" height="33">
            </a>
            <nav aria-label="Informazioni legali">
                <ul class="oid4vp-footer__links">
                    <li><button type="button" class="oid4vp-footer__link">Informativa Privacy</button></li>
                    <li><button type="button" class="oid4vp-footer__link">Diritto alla protezione dei dati personali</button></li>
                    <li><button type="button" class="oid4vp-footer__link">Termini e condizioni d'uso</button></li>
                    <li><button type="button" class="oid4vp-footer__link">Accessibilit&agrave;</button></li>
                </ul>
            </nav>
        </div>
        <div class="oid4vp-footer__bottom">
            <p><strong>PagoPA S.p.A.</strong> - Societ&agrave; per azioni con socio unico - Capitale sociale di euro 1,000,000 interamente versato - Sede legale in Roma, Piazza Colonna 370,<br>
                CAP 00187 - N. di iscrizione a Registro Imprese di Roma, CF e P.IVA 15376371009</p>
        </div>
    </footer>
</div>
</body>
</html>
</#macro>
