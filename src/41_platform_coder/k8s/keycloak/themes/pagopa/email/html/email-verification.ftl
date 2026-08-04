<#import "template.ftl" as layout>
<@layout.emailLayout>
${kcSanitize(msg("emailVerificationBodyHtml", link, linkExpirationFormatter(linkExpiration)))?no_esc}
</@layout.emailLayout>
