<#import "template.ftl" as layout>
<@layout.emailLayout>
${kcSanitize(msg("executeActionsBodyHtml", link, linkExpirationFormatter(linkExpiration)))?no_esc}
</@layout.emailLayout>
