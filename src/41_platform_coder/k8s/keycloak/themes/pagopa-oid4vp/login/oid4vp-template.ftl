<#import "footer.ftl" as loginFooter>
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
    <script src="${url.resourcesPath}/js/oid4vp-template.js" type="text/javascript"></script>
</head>
<body class="${properties.kcBodyClass!} pagopa-oid4vp-body">
<div class="page-container">
    <header class="header">
        <div class="header-logo">
            <span class="text-dark">PagoPA S.p.A.</span>
        </div>
    </header>

    <main class="main-content">
        <div class="${properties.kcLogin!} pagopa-oid4vp-shell">
            <div class="${properties.kcLoginContainer!}">
                <main class="${properties.kcLoginMain!}">
                    <div class="${properties.kcLoginMainHeader!}">
                        <h1 class="${properties.kcLoginMainTitle!}" id="kc-page-title"><#nested "header"></h1>
                    </div>
                    <div class="${properties.kcLoginMainBody!}">
                        <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                            <div class="${properties.kcAlertClass!} pf-m-${(message.type = 'error')?then('danger', message.type)}">
                                <span class="${properties.kcAlertTitleClass!} kc-feedback-text">${message.summary}</span>
                            </div>
                        </#if>
                        <#nested "form">
                    </div>
                    <div class="${properties.kcLoginMainFooter!}">
                        <@loginFooter.content/>
                    </div>
                </main>
            </div>
        </div>
    </main>

    <footer class="footer">
        <div class="footer-content">
            <div class="footer-columns">
                <div class="footer-column">
                    <div class="footer-logo">
                        <a href="https://www.pagopa.it/it/">
                            <svg class="pagopa-logo" viewBox="0 0 119 33" focusable="false" aria-labelledby="logo-pagoPA-company-titleID" role="img"><path opacity=".4" fill-rule="evenodd" clip-rule="evenodd" d="M114.338 25.099h3.718V2.324h-3.718v2.97a11.347 11.347 0 0 0-7.669-2.97 11.375 11.375 0 0 0-9.528 5.15 11.334 11.334 0 0 1 1.86 6.237 11.33 11.33 0 0 1-1.86 6.238 11.377 11.377 0 0 0 9.528 5.15c2.954 0 5.645-1.125 7.669-2.97v2.97ZM99 13.71a7.67 7.67 0 1 1 15.338 0 7.67 7.67 0 0 1-15.338 0ZM3.718 5.294v-2.97H0v29.282h3.718v-9.477a11.345 11.345 0 0 0 7.67 2.97c3.985 0 7.493-2.049 9.527-5.15a11.334 11.334 0 0 1-1.859-6.238c0-2.303.684-4.446 1.86-6.237a11.377 11.377 0 0 0-9.529-5.15 11.346 11.346 0 0 0-7.669 2.97Zm0 8.417a7.669 7.669 0 1 1 15.338 0 7.669 7.669 0 0 1-15.338 0Z"></path><path opacity=".7" fill-rule="evenodd" clip-rule="evenodd" d="M41.83 5.304v-2.98h-3.718v2.97a11.346 11.346 0 0 0-7.669-2.97c-6.288 0-11.387 5.098-11.387 11.387 0 6.29 5.099 11.388 11.387 11.388 2.954 0 5.646-1.125 7.67-2.97v2.97h3.718v-2.925a11.39 11.39 0 0 1-3.719-8.435c0-3.342 1.434-6.348 3.719-8.435Zm-19.055 8.407a7.669 7.669 0 1 1 15.338 0 7.669 7.669 0 0 1-15.338 0ZM79.944 5.293V2.324h-3.719v2.97a11.358 11.358 0 0 1 3.719 8.417c0 3.335-1.434 6.335-3.719 8.418v9.477h3.719v-9.477a11.346 11.346 0 0 0 7.669 2.97C93.902 25.099 99 20 99 13.71S93.902 2.324 87.613 2.324a11.346 11.346 0 0 0-7.669 2.97Zm0 8.418a7.669 7.669 0 1 1 15.338 0 7.669 7.669 0 0 1-15.338 0Z"></path><path fill-rule="evenodd" clip-rule="evenodd" d="M60.887 0v5.293l.157-.14a11.344 11.344 0 0 1 7.513-2.83c6.288 0 11.387 5.1 11.387 11.388 0 6.29-5.099 11.388-11.388 11.388a11.345 11.345 0 0 1-7.668-2.97v3.02c0 2.9-1.16 5.627-3.196 7.7l-.15.151-2.604-2.66c1.383-1.36 2.179-3.123 2.229-5.002l.002-.189v-2.975A11.333 11.333 0 0 1 49.5 25.15c-6.289 0-11.387-5.11-11.387-11.41 0-6.303 5.098-11.411 11.387-11.411 2.954 0 5.645 1.127 7.67 2.975V0h3.717ZM49.5 6.055c-4.235 0-7.669 3.44-7.669 7.684s3.434 7.685 7.67 7.685c4.235 0 7.668-3.44 7.668-7.685 0-4.244-3.433-7.684-7.669-7.684Zm11.388 7.656a7.669 7.669 0 1 1 15.338 0 7.669 7.669 0 0 1-15.338 0Z"></path><title id="logo-pagoPA-company-titleID">PagoPA</title></svg>
                        </a>
                    </div>
                    <ul>
                        <li><a href="https://pagopa.it/societa/chi-siamo/">PagoPA S.p.A.</a></li>
                        <li><a href="https://www.pagopa.it/it/opportunita/pnrr/progetti/">PNRR</a></li>
                        <li><a href="https://www.pagopa.it/it/media/">Media</a></li>
                        <li><a href="https://www.pagopa.it/it/lavora-con-noi/">Lavora con noi</a></li>
                    </ul>
                </div>
                <div class="footer-column">
                    <h2>PRODOTTI E SERVIZI</h2>
                    <ul>
                        <li><a href="https://www.pagopa.it/it/prodotti-e-servizi/app-io/">App IO</a></li>
                        <li><a href="https://www.pagopa.it/it/prodotti-e-servizi/piattaforma-pagopa/">Piattaforma pagoPA</a></li>
                        <li><a href="https://www.pagopa.it/it/prodotti-e-servizi/centro-stella-pagamenti-elettronici/">Centro stella</a></li>
                        <li><a href="https://www.pagopa.it/it/prodotti-e-servizi/check-iban/">Check IBAN</a></li>
                        <li><a href="https://www.pagopa.it/it/prodotti-e-servizi/piattaforma-notifiche-digitali/">Piattaforma Notifiche Digitali</a></li>
                    </ul>
                </div>
                <div class="footer-column">
                    <h2>RISORSE</h2>
                    <ul>
                        <li><a href="https://bonuselettrodomestici.it/esercente/privacy-policy">Informativa Privacy</a></li>
                        <li><a href="https://bonuselettrodomestici.it/esercente/terms-of-service">Termini e Condizioni</a></li>
                        <li><a href="https://www.pagopa.it/it/certificazioni/">Certificazioni</a></li>
                        <li><a href="https://www.pagopa.it/it/">Preferenze Cookie</a></li>
                        <li><a href="https://pagopa.portaleamministrazionetrasparente.it/">Societa trasparente</a></li>
                    </ul>
                </div>
                <div class="footer-column">
                    <h2>SEGUICI SU</h2>
                    <div class="social-icons">
                        <a aria-label="linkedin" href="https://www.linkedin.com/company/pagopa/" target="_blank" rel="noopener noreferrer">in</a>
                        <a aria-label="x.com" href="https://x.com/pagopa" target="_blank" rel="noopener noreferrer">x</a>
                        <a aria-label="instagram" href="https://www.instagram.com/pagopaspa/" target="_blank" rel="noopener noreferrer">ig</a>
                        <a aria-label="medium" href="https://medium.com/pagopa-spa" target="_blank" rel="noopener noreferrer">m</a>
                    </div>
                    <a href="https://form.agid.gov.it/view/9b5c6ed0-bbbb-11f0-a7e5-9bac06d781c9" class="footer-text">Accessibilita</a>
                    <div class="eu-logo">
                        <img src="${url.resourcesPath}/img/ue-logo.png" alt="Finanziato dall'Unione Europea">
                    </div>
                </div>
            </div>
            <div class="sub-footer">
                <span class="text-dark">PagoPA S.p.A.</span> - Societa per azioni con socio unico - Capitale sociale di euro 1.000.000 interamente versato
            </div>
        </div>
    </footer>
</div>
</body>
</html>
</#macro>
