<#import "template.ftl" as layout>
<@layout.emailLayout>
${kcSanitize(msg("passwordResetBodyHtml", link))?no_esc}
</@layout.emailLayout>
