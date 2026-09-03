
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
                <p>Il portale dedicato agli esercenti per gestire bonus e sconti</p>
                <form action="${url.loginAction}" method="post">
                    <div class="login-card">
                        <#if message?has_content && message.type != "warning">
                            <div id="kc-error-message">
                                <p>${message.summary}</p>
                            </div>
                        </#if>

                        <div class="form-group">
                            <input type="password" id="password-new" name="password-new" placeholder="Inserisci nuova password *" required>
                        </div>
                        <div class="form-group">
                            <input type="password" id="password-confirm" name="password-confirm" placeholder="Conferma password *" required>
                        </div>
                    </div>

                    <div class="password-policy-box">
                        <div class="password-policy-title">
                            <img class="password-policy-icon" src="${url.resourcesPath}/img/info-pass.png" alt="la tua password deve contenere" aria-hidden="true" />
                            <h2>La tua password deve contenere:</h2>
                        </div>
                        <ul>
                            <li>Tra i 10 e 64 caratteri</li>
                            <li>Almeno una maiuscola e una minuscola</li>
                            <li>Almeno un numero</li>
                            <li>Almeno un carattere speciale (es. ! @ # $)</li>
                        </ul>
                    </div>

                    <div class="terms-notice">
                        <span>Accedendo accetti i <a href="https://pari.pagopa.it/esercente/terms-of-service">Termini e condizioni d'uso</a> del servizio e confermi di avere letto l'<a href="https://pari.pagopa.it/esercente/privacy-policy">Informativa Privacy</a></span>
                    </div>

                    <input class="btn-primary" type="submit" value="Accedi" >

                </form>

            </div>
        </main>

        <#include "footer.ftl">
    </div>
    </body>
</html>
