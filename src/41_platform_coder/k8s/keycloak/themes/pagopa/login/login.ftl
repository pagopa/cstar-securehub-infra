
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accedi - Portale Esercenti</title>
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

        <main class="main-content">
            <div class="login-wrapper">
                <h1>Portale Punto Vendita</h1>
                <p>Il portale dedicato ai venditori per gestire bonus e sconti </p>

                <form action="${url.loginAction}" method="post">

                    <div class="login-card">
                        <#if message?has_content & message.type = "error">
                            <div id="kc-error-message">
                                <p>${message.summary}</p>
                            </div>
                          </#if>

                        <div class="form-group">
                            <input aria-label="Email" autocomplete="username" type="text" id="username" name="username" placeholder="Email *" value="${(login.username!'')}" required>
                        </div>
                        <div class="form-group">
                            <input type="password" id="password" name="password" placeholder="Password *" required>
                        </div>

                    <div class="${properties.kcFormGroupClass!} ${properties.kcFormSettingClass!}">
                            <div class="${properties.kcFormOptionsWrapperClass!} forgot-password">
                                <#if realm.resetPasswordAllowed>
                                    <span><a tabindex="6" href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a></span>
                                </#if>
                            </div>

                      </div>
                    </div>

                    <div class="terms-notice">
                        <span>Accedendo accetti i <a href="https://pari.pagopa.it/esercente/terms-of-service">Termini e condizioni d'uso</a> del servizio e confermi di avere letto l'<a href="https://pari.pagopa.it/esercente/privacy-policy">Informativa Privacy</a></span>
                    </div>

                    <input class="btn-primary" type="submit" value="Accedi">

                </form>
            </div>
                <#if message?has_content & message.type = "success">
                    <div id="kc-success-message">
                        <img class="check-circle-icon" src="${url.resourcesPath}/img/check-circle.png" alt="success" aria-hidden="true" />
                        <p>${message.summary}</p>
                    </div>
                </#if>
        </main>

        <#include "footer.ftl">
    </div>
    </body>
</html>
