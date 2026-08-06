<#macro emailLayout emailTitle>
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

      .btn-primary {
        display: inline-block;
        width: fit-content;
        padding: 1rem;
        background-color: #0073e6;
        color: #ffffff;
        border: none;
        border-radius: 4px;
        font-size: 16px;
        font-weight: 700;
        cursor: pointer;
        transition: background-color 0.3s;
        height: 48px;
        line-height: 1;
      }

      .btn-primary:hover {
        background-color: #005bb5;
      }
    </style>
  </head>
  <body>
		<div class="pageWrapper">
			<header>
				<div style="padding-bottom: 2rem">
					<div style="height: 5.063rem">
						<img width="119" height="33" src="https://selfcare.pagopa.it/assets/logo_pagopacorp.png" alt="PagoPa logo"/>
					</div>
					<h1 style="font-size: 32px; line-height: 40px; font-weight: 700; letter-spacing: 0;">${emailTitle}</h1>
				</div>
			</header>
			<table class="content">
        <tbody>
          <#nested>
        </tbody>
        <tfoot style="font-size: 14px;line-height: 20px;color: #a2adb8;">
          <tr>
            <td style="border-top: 1px solid #e3e7eb;padding-top: 1.563rem;">${msg("emailFooter")}</td>
          </tr>
        </tfoot>
      </table>
    </div>
  </body>
</html>
</#macro>
