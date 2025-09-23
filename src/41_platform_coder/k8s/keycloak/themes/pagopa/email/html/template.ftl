<#macro emailLayout>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
    <style>
      @import url("https://fonts.googleapis.com/css2?family=Titillium+Web:ital,wght@0,200;0,300;0,400;0,600;0,700;0,900;1,200;1,300;1,400;1,600;1,700&display=swap");

      * {
        margin: 0;
        padding: 0;
        border: none;
        box-sizing: border-box;
      }

      .pageWrapper {
        font-family: "Titillium Web", "Helvetica Neue", Helvetica, Arial,
          sans-serif;
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
      <div style="height: 5.063rem">
      <img
          src="${url.resourcesPath}/images/logo.png"
          width="119px"
          height="33px"
          alt="logo"
        />
      </div>
        <h1
            style="
              font-size: 32px;
              line-height: 40px;
              font-weight: 700;
              letter-spacing: 0;
              padding-bottom: 2rem;
            "
          >
          Il tuo account su Bonus Elettrodomestici è stato attivato
        </h1>
      </header>
      <table class="content">
        <tbody>
          <tr>
            <td style="padding-bottom: 3rem">Ciao,</td>
          </tr>
          <tr>
            <td style="padding-bottom: 3rem">
              ti comunichiamo che il tuo account per accedere al portale Bonus
              Elettrodomestici è stato attivato.
            </td>
          </tr>
          <tr>
            <td style="padding-bottom: 3rem">
              Per completare l’accesso, imposta la tua password cliccando sul
              link qui sotto:
            </td>
          </tr>
          <tr>
            <td style="padding-bottom: 3rem">
              <a style="color: #0073e6" href="${link}"
                >Imposta la tua password</a
              >
            </td>
          </tr>
          <tr>
            <td style="padding-bottom: 3rem">
              Una volta impostata, potrai accedere al portale con la tua e-mail
              aziendale e la nuova password.
            </td>
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
            <td>A presto,</td>
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
