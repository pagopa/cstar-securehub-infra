<#macro emailLayout>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:ital,wght@0,200..1000;1,200..1000&family=Titillium+Web:ital,wght@0,200;0,300;0,400;0,600;0,700;0,900;1,200;1,300;1,400;1,600;1,700&display=swap" rel="stylesheet">
    <style>
      * {
        margin: 0;
        padding: 0;
        border: none;
        box-sizing: border-box;
      }

      .pageWrapper {
        font-family: "Titillium Web", "Helvetica Neue", Helvetica, Arial, sans-serif;
        color: #17324d;
        font-size: 18px;
        line-height: 24px;
        font-weight: 400;
        padding: 10%;
      }

      .content {
        margin-right: 5.625rem;
      }
    </style>
  </head>
  <body>
    <div class="pageWrapper">
      <header>
      <div style="padding-bottom: 2rem">
      <div style="height: 5.063rem">
      <img width="119px" height="33px" src="https://selfcare.pagopa.it/assets/logo_pagopacorp.png" alt="PagoPa logo"/>
      </div>
        <h1
            style="
              font-size: 32px;
              line-height: 40px;
              font-weight: 700;
              letter-spacing: 0;
            "
          >
          Il tuo profilo sul portale del Bonus Elettrodomestici è stato attivato
        </h1>
        </div>
      </header>
      <table class="content">
        <tbody>
          <tr>
            <td style="padding-bottom: 3rem">Ciao,</td>
          </tr>
          <tr>
            <td style="padding-bottom: 3rem">
              ti comunichiamo che il tuo profilo per accedere al portale del Bonus Elettrodomestici è stato attivato.
            </td>
          </tr>
          <tr>
            <td style="padding-bottom: 3rem">
              Per poter accedere la prima volta, <b style="font-weight: 600">imposta una password</b>. <br/>
              Una volta fatto, potrai accedere al portale con il tuo indirizzo email e la password che hai scelto.
            </td>
          </tr>
          <tr>
            <td style="padding-bottom: 0.5rem">
              <a style="color: #0073e6" href="${link}"
                >Imposta la tua password</a
              >
            </td>
          </tr>
          <tr>
            <td style="padding-bottom: 3rem">Il link per impostare la password sarà valido per i prossimi ${(linkExpiration / 24) / 60} giorni.</td>
          </tr>
          <tr>
            <td style="padding-bottom: 3rem">
              <b style="font-weight: 600">Hai problemi tecnici o domande?</b>
              Scrivi a
              <a
                style="color: #0073e6"
                href="mailto:portale.bonus@assistenza.pagopa.it"
                >portale.bonus@assistenza.pagopa.it.</a
              >
            </td>
          </tr>
          <tr>
            <td style="padding-bottom: 0.5rem">A presto,</td>
          </tr>
          <tr>
            <td style="padding-bottom: 1.563rem">il team di Portale Bonus</td>
          </tr>
        </tbody>
        <tfoot style="
          font-size: 14px;
          line-height: 20px;
          color: #a2adb8;
        ">
        <tr>
          <td style="
          border-top: 1px solid #e3e7eb;
          padding-top: 1.563rem;
          ">
          Ricevi questo messaggio perché hai un’utenza attiva nel Portale Bonus.</td>
        </tr>
      </tfoot>
      </table>
    </div>
  </body>
</html>
</#macro>
