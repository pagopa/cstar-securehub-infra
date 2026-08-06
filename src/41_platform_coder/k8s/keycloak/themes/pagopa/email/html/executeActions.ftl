<#import "template.ftl" as layout>
<@layout.emailLayout emailTitle=msg("executeActionsTitle")>
    <tr>
        <td style="padding-bottom: 3rem">
            ${msg("emailGreetings")}
        </td>
    </tr>
    <tr>
        <td style="padding-bottom: 3rem">
            ${msg("emailVerificationInput")}
        </td>
    </tr>
    <tr>
        <td style="padding-bottom: 3rem">
            ${msg("emailVerificationInstructions1")} <b style="font-weight: 600">${msg("emailVerificationInstructions2")}</b>. <br/>
            ${msg("emailVerificationInstructions3")}
        </td>
    </tr>
    <tr>
        <td style="padding-bottom: 0.5rem">
            <a style="color: #0073e6" href="${link}">${msg("emailVerificationLink")}</a>
        </td>
    </tr>
    <tr>
        <td style="padding-bottom: 3rem">
            ${msg("emailVerificationLinkInfo", linkExpirationFormatter(linkExpiration))}
        </td>
    </tr>
    <tr>
        <td style="padding-bottom: 3rem">
            <b style="font-weight: 600">${msg("emailHelp")}</b> ${msg("emailMailTo")} <a style="color: #0073e6" href="mailto:${msg("emailVerificationEmail")}">${msg("emailVerificationEmail")}</a>.
        </td>
    </tr>
    <tr>
        <td style="padding-bottom: 0.5rem">
            ${msg("emailRegards")}
        </td>
    </tr>
    <tr>
        <td style="padding-bottom: 1.563rem">
            ${msg("emailRegardsFrom")}
        </td>
    </tr>
</@layout.emailLayout>
