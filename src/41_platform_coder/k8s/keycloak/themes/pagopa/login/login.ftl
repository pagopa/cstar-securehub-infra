
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accedi - Portale Esercenti</title>
    <link href="${url.resourcesPath}/css/login.css" rel="stylesheet">
</head>
<body>
    <div class="page-container">
        <header class="header">
            <div class="header-logo">
                <p class="text-dark">PagoPA S.p.A.</p>
            </div>
            <nav class="header-nav">
                <a href="#" class="text-dark-light">
                    <img src="${url.resourcesPath}/img/book.png"/>
                    Manuale operativo
                </a>
                <a href="#" class="text-dark-light">
                    <img src="${url.resourcesPath}/img/info.png"/>
                    Assistenza
                </a>
            </nav>
        </header>

        <main class="main-content">
            <div class="login-wrapper">
                <h1>Portale Esercenti</h1>
                <p>Il prodotto dedicato agli esercenti che utilizzano la piattaforma PARI</p>

                <form action="${url.loginAction}" method="post">
                    
                    <div class="login-card">
                        <#if message?has_content>
                            <div id="kc-error-message">
                                <p>${message.summary}</p>
                            </div>
                        </#if>
                        
                        <div class="form-group">
                            <input type="text" id="username" name="username" placeholder="Email" value="${(login.username!'')}" required>
                        </div>
                        <div class="form-group">
                            <input type="password" id="password" name="password" placeholder="Password" required>
                        </div>
                    </div>

                    <div class="terms-notice">
                        <span>Accedendo accetti i <a href="#">Termini e condizioni d'uso</a> del servizio e confermi di avere letto l'<a href="#">Informativa Privacy</a></span>
                    </div>
                    
                    <input class="btn-primary" type="submit" value="Accedi">

                </form>
            </div>
        </main>

        <footer class="footer">
            <div class="footer-content">
                <div class="footer-columns">
                    <div class="footer-column">
                        <div class="footer-logo">
                            <img src=${url.resourcesPath}/img/pagopa-logo.png alt="PagoPA S.p.A.">
                        </div>
                        <ul>
                            <li><a href="#">PagoPA S.p.A.</a></li>
                            <li><a href="#">PNRR</a></li>
                            <li><a href="#">Media</a></li>
                            <li><a href="#">Lavora con noi</a></li>
                        </ul>
                    </div>
                    <div class="footer-column">
                        <h4>PRODOTTI E SERVIZI</h4>
                        <ul>
                            <li><a href="#">App IO</a></li>
                            <li><a href="#">Piattaforma pagoPA</a></li>
                            <li><a href="#">Centro stella</a></li>
                            <li><a href="#">Check IBAN</a></li>
                            <li><a href="#">Piattaforma Notifiche Digitali</a></li>
                            <li><a href="#">Piattaforma Digitale Nazionale Dati</a></li>
                            <li><a href="#">Interoperabilità</a></li>
                            <li><a href="#">Area Riservata</a></li>
                        </ul>
                    </div>
                    <div class="footer-column">
                        <h4>RISORSE</h4>
                        <ul>
                            <li><a href="#">Informativa Privacy</a></li>
                            <li><a href="#">Termini e Condizioni</a></li>
                            <li><a href="#">Certificazioni</a></li>
                            <li><a href="#">Sicurezza delle informazioni</a></li>
                            <li><a href="#">Diritto alla protezione dei dati personali</a></li>
                            <li><a href="#">Preferenze Cookie</a></li>
                            <li><a href="#">Società trasparente</a></li>
                            <li><a href="#">Responsabile Disclosure Policy</a></li>
                            <li><a href="#">Modello 231</a></li>
                        </ul>
                    </div>
                    <div class="footer-column">
                        <h4>SEGUICI SU</h4>
                        <div class="social-icons">
                            <img src="${url.resourcesPath}/img/linkedin-logo.png" alt="LinkedIn">
                            <img src="${url.resourcesPath}/img/twitter-logo.png" alt="Twitter">
                            <img src="${url.resourcesPath}/img/instagram-logo.png" alt="Instagram">
                            <img src="${url.resourcesPath}/img/medium-logo.png" alt="Medium">
                        </div>
                        <a href="#" aria-label="Accessibilità" class="footer-text">Accessibilità</a>
                        <br><br>
                        <a href="#" class="footer-text">Italiano &#9662;</a>
                        <div class="eu-logo">
                            <img src="${url.resourcesPath}/img/ue-logo.png" alt="Finanziato dall'Unione Europea">
                        </div>
                    </div>
                </div>
                <div class="sub-footer">
                    PagoPA S.p.A. – Società per azioni con socio unico – Capitale sociale di euro 1.000.000 interamente versato - Sede legale in Roma, Piazza Colonna 370, CAP 00187 - N. di iscrizione a Registro Imprese di Roma, CF e P.IVA 15376371009
                </div>
            </div>
        </footer>
    </div>
    </body>
</html>