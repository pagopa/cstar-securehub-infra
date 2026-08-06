<#import "template.ftl" as layout>
<@layout.emailLayout emailTitle=msg("passwordResetTitle")>
    <tr>
        <td style="padding-bottom: 3rem">
            ${msg("emailGreetings")}
        </td>
    </tr>
    <tr>
        <td style="padding-bottom: 0.5rem">
            ${msg("passwordResetInput")}
        </td>
    </tr>
    <tr>
        <td style="padding-bottom: 3rem">
            ${msg("passwordResetLinkInstructions")}
        </td>
    </tr>
    <tr>
        <td style="padding-bottom: 3rem">
            <a style="color: #0073e6" href="${link}">${msg("passwordResetLink")}</a>
        </td>
    </tr>
    <tr>
        <td style="padding-bottom: 3rem">
            ${msg("passwordResetLinkInfo")}
        </td>
    </tr>
    <tr>
        <td style="padding-bottom: 1rem">
            ${msg("passwordResetSecurityInfo")}
        </td>
    </tr>
    <tr>
        <td style="padding-bottom: 3rem">
            <ul>
                <li>${msg("passwordResetSecurityList1")}</li>
                <li>${msg("passwordResetSecurityList2")}</li>
                <li>${msg("passwordResetSecurityList3")}</li>
                <li>${msg("passwordResetSecurityList4")}</li>
            </ul>
        </td>
    </tr>
    <tr>
        <td style="padding-bottom: 3rem">
            <b style="font-weight: 600">${msg("emailHelp")}</b> ${msg("emailMailTo")} <br/><a style="color: #0073e6" href="mailto:${msg("passwordResetEmail")}">${msg("passwordResetEmail")}</a>.
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
    <tr>
        <td style="padding-top: 1.563rem; padding-bottom: 1.563rem">
            <div class="btn-primary">
                <a style="text-decoration: none; color: #ffffff;" href="${link}">${msg("passwordResetCTA")}</a>
            </div>
        </td>
    </tr>
</@layout.emailLayout>
