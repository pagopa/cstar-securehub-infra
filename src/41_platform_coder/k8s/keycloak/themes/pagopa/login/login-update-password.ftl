
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
                <a href="https://developer.pagopa.it/pari/guides/manuale-tecnico-venditore" class="text-dark-light">
                    <img src="${url.resourcesPath}/img/book.png"/>
                    Manuale operativo
                </a>
                <a href="https://developer.pagopa.it/pari/guides/manuale-tecnico-venditore/contatti" class="text-dark-light">
                    <img src="${url.resourcesPath}/img/info.png"/>
                    Assistenza
                </a>
            </nav>
        </header>

        <main class="main-content">
            <div class="login-wrapper">
                <h1>Bonus Elettrodomestici</h1>
                <p>Il portale dedicato agli esercenti per gestire bonus e sconti </p>
                <form action="${url.loginAction}" method="post">
                    <div class="login-card">
                        <#if message?has_content && message.type != "warning">
                            <div id="kc-error-message">
                                <p>${message.summary}</p>
                            </div>
                        </#if>

                        <div class="form-group">
                            <input type="password" id="password-new" name="password-new" placeholder="Inserisci nuova password" required>
                        </div>
                        <div class="form-group">
                            <input type="password" id="password-confirm" name="password-confirm" placeholder="Conferma password" required>
                        </div>
                    </div>

                    <div class="terms-notice">
                        <span>Accedendo accetti i <a href="https://selfcare.pagopa.it/auth/termini-di-servizio">Termini e condizioni d'uso</a> del servizio e confermi di avere letto l'<a href="https://selfcare.pagopa.it/auth/informativa-privacy">Informativa Privacy</a></span>
                    </div>

                    <input class="btn-primary" type="submit" value="Accedi" >

                </form>

            </div>
        </main>

        <footer class="footer">
            <div class="footer-content">
                <div class="footer-columns">
                    <div class="footer-column">
                        <div class="footer-logo">
                            <a href="https://www.pagopa.it/it/">

                              <svg class="pagopa-logo" viewBox="0 0 119 33" focusable="false" aria-labelledby="logo-pagoPA-company-titleID" role="img" class="css-zr5gjd"><path opacity=".4" fill-rule="evenodd" clip-rule="evenodd" d="M114.338 25.099h3.718V2.324h-3.718v2.97a11.347 11.347 0 0 0-7.669-2.97 11.375 11.375 0 0 0-9.528 5.15 11.334 11.334 0 0 1 1.86 6.237 11.33 11.33 0 0 1-1.86 6.238 11.377 11.377 0 0 0 9.528 5.15c2.954 0 5.645-1.125 7.669-2.97v2.97ZM99 13.71a7.67 7.67 0 1 1 15.338 0 7.67 7.67 0 0 1-15.338 0ZM3.718 5.294v-2.97H0v29.282h3.718v-9.477a11.345 11.345 0 0 0 7.67 2.97c3.985 0 7.493-2.049 9.527-5.15a11.334 11.334 0 0 1-1.859-6.238c0-2.303.684-4.446 1.86-6.237a11.377 11.377 0 0 0-9.529-5.15 11.346 11.346 0 0 0-7.669 2.97Zm0 8.417a7.669 7.669 0 1 1 15.338 0 7.669 7.669 0 0 1-15.338 0Z"></path><path opacity=".7" fill-rule="evenodd" clip-rule="evenodd" d="M41.83 5.304v-2.98h-3.718v2.97a11.346 11.346 0 0 0-7.669-2.97c-6.288 0-11.387 5.098-11.387 11.387 0 6.29 5.099 11.388 11.387 11.388 2.954 0 5.646-1.125 7.67-2.97v2.97h3.718v-2.925a11.39 11.39 0 0 1-3.719-8.435c0-3.342 1.434-6.348 3.719-8.435Zm-19.055 8.407a7.669 7.669 0 1 1 15.338 0 7.669 7.669 0 0 1-15.338 0ZM79.944 5.293V2.324h-3.719v2.97a11.358 11.358 0 0 1 3.719 8.417c0 3.335-1.434 6.335-3.719 8.418v9.477h3.719v-9.477a11.346 11.346 0 0 0 7.669 2.97C93.902 25.099 99 20 99 13.71S93.902 2.324 87.613 2.324a11.346 11.346 0 0 0-7.669 2.97Zm0 8.418a7.669 7.669 0 1 1 15.338 0 7.669 7.669 0 0 1-15.338 0Z"></path><path fill-rule="evenodd" clip-rule="evenodd" d="M60.887 0v5.293l.157-.14a11.344 11.344 0 0 1 7.513-2.83c6.288 0 11.387 5.1 11.387 11.388 0 6.29-5.099 11.388-11.388 11.388a11.345 11.345 0 0 1-7.668-2.97v3.02c0 2.9-1.16 5.627-3.196 7.7l-.15.151-2.604-2.66c1.383-1.36 2.179-3.123 2.229-5.002l.002-.189v-2.975A11.333 11.333 0 0 1 49.5 25.15c-6.289 0-11.387-5.11-11.387-11.41 0-6.303 5.098-11.411 11.387-11.411 2.954 0 5.645 1.127 7.67 2.975V0h3.717ZM49.5 6.055c-4.235 0-7.669 3.44-7.669 7.684s3.434 7.685 7.67 7.685c4.235 0 7.668-3.44 7.668-7.685 0-4.244-3.433-7.684-7.669-7.684Zm11.388 7.656a7.669 7.669 0 1 1 15.338 0 7.669 7.669 0 0 1-15.338 0Z"></path><title id="logo-pagoPA-company-titleID">PagoPA</title></svg>
                            </a>
                        </div>
                        <ul>
                            <li><a href="https://www.pagopa.it/it/societa/chi-siamo/">PagoPA S.p.A.</a></li>
                            <li><a href="#">PNRR</a></li>
                            <li><a href="https://www.pagopa.it/it/">Media</a></li>
                            <li><a href="https://www.pagopa.it/it/lavora-con-noi/">Lavora con noi</a></li>
                        </ul>
                    </div>
                    <div class="footer-column">
                        <h4>PRODOTTI E SERVIZI</h4>
                        <ul>
                            <li><a href="https://www.pagopa.it/it/prodotti-e-servizi/app-io">App IO</a></li>
                            <li><a href="https://www.pagopa.it/it/prodotti-e-servizi/piattaforma-pagopa">Piattaforma pagoPA</a></li>
                            <li><a href="https://www.pagopa.it/it/prodotti-e-servizi/centro-stella-pagamenti-elettronici">Centro stella</a></li>
                            <li><a href="https://www.pagopa.it/it/prodotti-e-servizi/check-iban">Check IBAN</a></li>
                            <li><a href="https://www.pagopa.it/it/prodotti-e-servizi/piattaforma-notifiche-digitali">Piattaforma Notifiche Digitali</a></li>
                            <li><a href="#">Piattaforma Digitale Nazionale Dati - <br />Interoperabilità</a></li>
                            <li><a href="https://docs.pagopa.it/area-riservata/">Area Riservata</a></li>
                        </ul>
                    </div>
                    <div class="footer-column">
                        <h4>RISORSE</h4>
                        <ul>
                            <li><a href="https://selfcare.pagopa.it/auth/informativa-privacy">Informativa Privacy</a></li>
                            <li><a href="https://selfcare.pagopa.it/auth/termini-di-servizio">Termini e Condizioni</a></li>
                            <li><a href="https://www.pagopa.it/it/certificazioni/">Certificazioni</a></li>
                            <li><a href="https://oneid.pagopa.it/login?response_type=CODE&scope=openid&client_id=0GemhuNwzjygMbWHJjYCMInHkYInwDjax7xQ-lFqiUs&state=145f2339797f4ce&nonce=e2a3b40c1238439&redirect_uri=https%3A%2F%2Fuat.selfcare.pagopa.it%2Fauth%2Flogin%2Fcallback">Sicurezza delle informazioni</a></li>
                            <li><a href="https://privacyportal-de.onetrust.com/webform/77f17844-04c3-4969-a11d-462ee77acbe1/9ab6533d-be4a-482e-929a-0d8d2ab29df8">Diritto alla protezione dei dati personali</a></li>
                            <li><a href="https://www.pagopa.it/it/">Preferenze Cookie</a></li>
                            <li><a href="https://pagopa.portaleamministrazionetrasparente.it/">Società trasparente</a></li>
                            <li><a href="https://www.pagopa.it/it/responsible-disclosure-policy/">Responsabile Disclosure Policy</a></li>
                            <li><a href="https://pagopa.portaleamministrazionetrasparente.it/pagina746_altri-contenuti.html">Modello 231</a></li>
                        </ul>
                    </div>
                    <div class="footer-column">
                        <h4>SEGUICI SU</h4>
                        <div class="social-icons">
                          <a href="https://www.linkedin.com/company/pagopa/mycompany/" target="_blank" rel="noopener noreferrer">

                              <svg class="social-icon-svg MuiSvgIcon-root MuiSvgIcon-fontSizeMedium css-14yq2cq" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="LinkedInIcon"><path d="M19 3a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14m-.5 15.5v-5.3a3.26 3.26 0 0 0-3.26-3.26c-.85 0-1.84.52-2.32 1.3v-1.11h-2.79v8.37h2.79v-4.93c0-.77.62-1.4 1.39-1.4a1.4 1.4 0 0 1 1.4 1.4v4.93h2.79M6.88 8.56a1.68 1.68 0 0 0 1.68-1.68c0-.93-.75-1.69-1.68-1.69a1.69 1.69 0 0 0-1.69 1.69c0 .93.76 1.68 1.69 1.68m1.39 9.94v-8.37H5.5v8.37h2.77z"></path></svg>
                          </a>
                          <a href="https://x.com/pagopa" target="_blank" rel="noopener noreferrer">
                              <svg class="social-icon-svg MuiSvgIcon-root MuiSvgIcon-fontSizeMedium css-14yq2cq" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="TwitterIcon"><path d="M22.46 6c-.77.35-1.6.58-2.46.69.88-.53 1.56-1.37 1.88-2.38-.83.5-1.75.85-2.72 1.05C18.37 4.5 17.26 4 16 4c-2.35 0-4.27 1.92-4.27 4.29 0 .34.04.67.11.98C8.28 9.09 5.11 7.38 3 4.79c-.37.63-.58 1.37-.58 2.15 0 1.49.75 2.81 1.91 3.56-.71 0-1.37-.2-1.95-.5v.03c0 2.08 1.48 3.82 3.44 4.21a4.22 4.22 0 0 1-1.93.07 4.28 4.28 0 0 0 4 2.98 8.521 8.521 0 0 1-5.33 1.84c-.34 0-.68-.02-1.02-.06C3.44 20.29 5.7 21 8.12 21 16 21 20.33 14.46 20.33 8.79c0-.19 0-.37-.01-.56.84-.6 1.56-1.36 2.14-2.23z"></path></svg>
                          </a>
                          <a href="https://www.instagram.com/pagopaspa/" target="_blank" rel="noopener noreferrer">
                              <svg class="social-icon-svg MuiSvgIcon-root MuiSvgIcon-fontSizeMedium css-14yq2cq" focusable="false" aria-hidden="true" viewBox="0 0 24 24" data-testid="InstagramIcon"><path d="M7.8 2h8.4C19.4 2 22 4.6 22 7.8v8.4a5.8 5.8 0 0 1-5.8 5.8H7.8C4.6 22 2 19.4 2 16.2V7.8A5.8 5.8 0 0 1 7.8 2m-.2 2A3.6 3.6 0 0 0 4 7.6v8.8C4 18.39 5.61 20 7.6 20h8.8a3.6 3.6 0 0 0 3.6-3.6V7.6C20 5.61 18.39 4 16.4 4H7.6m9.65 1.5a1.25 1.25 0 0 1 1.25 1.25A1.25 1.25 0 0 1 17.25 8 1.25 1.25 0 0 1 16 6.75a1.25 1.25 0 0 1 1.25-1.25M12 7a5 5 0 0 1 5 5 5 5 0 0 1-5 5 5 5 0 0 1-5-5 5 5 0 0 1 5-5m0 2a3 3 0 0 0-3 3 3 3 0 0 0 3 3 3 3 0 0 0 3-3 3 3 0 0 0-3-3z"></path></svg>
                          </a>
                          <a href="https://medium.com/pagopa-spa" target="_blank" rel="noopener noreferrer">
                              <svg class="social-icon-svg MuiSvgIcon-root MuiSvgIcon-fontSizeMedium css-14yq2cq" focusable="false" aria-hidden="true" viewBox="0 0 1043.63 592.71"><path d="M588.67 296.36c0 163.67-131.78 296.35-294.33 296.35S0 460 0 296.36 131.78 0 294.34 0s294.33 132.69 294.33 296.36M911.56 296.36c0 154.06-65.89 279-147.17 279s-147.17-124.94-147.17-279 65.88-279 147.16-279 147.17 124.9 147.17 279M1043.63 296.36c0 138-23.17 249.94-51.76 249.94s-51.75-111.91-51.75-249.94 23.17-249.94 51.75-249.94 51.76 111.9 51.76 249.94"></path></svg>
                          </a>
                        ˙</div>
                        <a href="https://form.agid.gov.it/view/0947e110-df2e-11ef-8637-9f856ac3da10" aria-label="Accessibilità" class="footer-text">Accessibilità</a>
                        <br><br>
                        <a href="#" class="footer-text">Italiano &#9662;</a>
                        <div class="eu-logo">
                            <img src="${url.resourcesPath}/img/ue-logo.png" alt="Finanziato dall'Unione Europea">
                        </div>
                    </div>
                </div>
                <div class="sub-footer">
                    <span class="text-dark">PagoPA S.p.A. </span> – Società per azioni con socio unico – Capitale sociale di euro 1.000.000 interamente versato - Sede legale in Roma, Piazza Colonna 370, CAP 00187 - N. di iscrizione a Registro Imprese di Roma, CF e P.IVA 15376371009
                </div>
            </div>
        </footer>
    </div>
    </body>
</html>
