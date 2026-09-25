<#import "oid4vp-template.ftl" as layout>
<#assign oid4vpCancelUrl = "">
<#if client?? && (client.baseUrl!'')?has_content>
    <#assign oid4vpCancelUrl = client.baseUrl>
</#if>
<@layout.registrationLayout displayInfo=false cancelUrl=oid4vpCancelUrl; section>
    <#if section = "header">
        Inquadra il codice QR
    <#elseif section = "form">
        <form id="oid4vpForm" action="${formActionUrl!''}" method="post">
            <input type="hidden" id="state" name="state" value="${state!''}"/>
            <input type="hidden" id="requestHandle" value="${requestHandle!''}"/>
            <input type="hidden" id="crossDeviceRequestHandle" value="${crossDeviceRequestHandle!''}"/>
            <input type="hidden" id="vp_token" name="vp_token"/>
            <input type="hidden" id="response" name="response"/>
            <input type="hidden" id="error" name="error"/>
            <input type="hidden" id="error_description" name="error_description"/>
        </form>

        <#if (crossDeviceEnabled!false) && (qrCodeBase64!'')?has_content>
            <div class="oid4vp-qr-wrap">
                <div class="oid4vp-qr-frame">
                    <img id="oid4vp-qr-code"
                         src="data:image/png;base64,${qrCodeBase64!''}"
                         alt="${msg("oid4vpQrCodeAlt")}"
                         data-wallet-url="${crossDeviceWalletUrl!''}"/>
                </div>
                <p id="oid4vp-qr-countdown" class="oid4vp-qr-status" hidden aria-hidden="true">
                    Il codice QR &egrave; valido per <strong id="oid4vp-qr-remaining"></strong> secondi
                </p>
                <p id="oid4vp-qr-status"
                   class="oid4vp-qr-status"
                   role="status"
                   hidden
                   aria-hidden="true">
                    Il QR Code &egrave; scaduto
                </p>
                <#if oid4vpCancelUrl?has_content>
                    <a class="oid4vp-cancel-link"
                       href="${oid4vpCancelUrl}">
                        Annulla
                    </a>
                </#if>
                <button id="oid4vp-refresh-btn"
                        type="button"
                        class="oid4vp-refresh-button">
                    Aggiorna QR Code
                </button>
            </div>
        </#if>

        <#if (crossDeviceStatusUrl!'')?has_content && (crossDeviceEnabled!false)>
            <div id="oid4vp-cross-device-sse-config"
                 data-status-url="${crossDeviceStatusUrl!''}"
                 data-refresh-url="${crossDeviceRefreshUrl!''}"
                 data-request-handle="${crossDeviceRequestHandle!''}"
                 data-expires-at="${(qrCodeExpiresAt!0)?c}"
                 data-server-time="${(qrCodeServerTime!0)?c}"
                 hidden></div>
            <script nonce="${cspNonce!}" src="${url.resourcesPath}/js/oid4vp-cross-device-sse.js"></script>
        </#if>
    </#if>
</@layout.registrationLayout>
