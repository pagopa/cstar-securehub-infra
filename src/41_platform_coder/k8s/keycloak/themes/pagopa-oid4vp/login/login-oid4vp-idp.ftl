<#import "oid4vp-template.ftl" as layout>
<#assign oid4vpCancelUrl = "">
<#if client?? && (client.baseUrl!'')?has_content>
    <#assign oid4vpCancelUrl = client.baseUrl>
</#if>
<@layout.registrationLayout displayInfo=false cancelUrl=oid4vpCancelUrl; section>
    <#if section = "header">
        Inquadra il codice QR
    <#elseif section = "form">
        <div id="oid4vp-browser-refresh-config" data-refresh-url="${url.loginUrl}" data-cancel-url="${oid4vpCancelUrl}" hidden></div>
        <#list properties.scripts?split(' ') as script>
            <script nonce="${cspNonce!}" src="${url.resourcesPath}/${script}"></script>
        </#list>
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
                    <button id="oid4vp-refresh-btn"
                            type="button"
                            class="oid4vp-refresh-button">
                        <svg width="23" height="24" viewBox="0 0 23 24" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" focusable="false">
                            <path fill-rule="evenodd" clip-rule="evenodd" d="M20.5 20.4706V22.5C20.5 23.0523 20.9477 23.5 21.5 23.5C22.0523 23.5 22.5 23.0523 22.5 22.5V18C22.5 17.7348 22.3946 17.4804 22.2071 17.2929C22.0196 17.1053 21.7652 17 21.5 17L17 17C16.4477 17 16 17.4477 16 18C16 18.5523 16.4477 19 17 19L19.1415 19C18.1875 19.9732 17.0395 20.7463 15.7641 21.2645C13.8729 22.0329 11.792 22.2041 9.80074 21.7552C7.80948 21.3062 6.00329 20.2587 4.6248 18.7532C3.2463 17.2478 2.36153 15.3565 2.08933 13.3335C1.81712 11.3105 2.17052 9.25267 3.10206 7.43639C4.0336 5.62011 5.49865 4.1324 7.30043 3.17311C9.1022 2.21381 11.1544 1.82888 13.1813 2.07001C15.2083 2.31115 17.1129 3.1668 18.6393 4.52204C19.0523 4.88872 19.6843 4.85117 20.051 4.43817C20.4177 4.02518 20.3802 3.39313 19.9672 3.02645C18.1354 1.40017 15.8499 0.373381 13.4176 0.0840187C10.9853 -0.205345 8.52264 0.256577 6.36051 1.40773C4.19838 2.55888 2.44032 4.34413 1.32247 6.52367C0.204625 8.7032 -0.219459 11.1726 0.107188 13.6002C0.433835 16.0278 1.49556 18.2973 3.14976 20.1039C4.80395 21.9104 6.97137 23.1675 9.36088 23.7062C11.7504 24.2449 14.2475 24.0395 16.5169 23.1175C18.0165 22.5082 19.3692 21.6053 20.5 20.4706Z" fill="white"/>
                        </svg>
                        <span>Genera un nuovo codice</span>
                    </button>
                </div>
                <p id="oid4vp-qr-countdown" class="oid4vp-qr-status" hidden aria-hidden="true">
                    Il codice QR &egrave; valido per <strong id="oid4vp-qr-remaining"></strong> secondi
                </p>
                <p id="oid4vp-qr-status"
                   class="oid4vp-qr-status"
                   role="status"
                   hidden
                   aria-hidden="true">
                    <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" focusable="false">
                        <path fill-rule="evenodd" clip-rule="evenodd" d="M0 10C0 4.47715 4.47715 0 10 0C12.6522 0 15.1957 1.05357 17.0711 2.92893C18.9464 4.8043 20 7.34784 20 10C20 15.5228 15.5228 20 10 20C4.47715 20 0 15.5228 0 10ZM1 10C1 14.9706 5.02944 19 10 19C14.9706 19 19 14.9706 19 10C19 5.02944 14.9706 1 10 1C5.02944 1 1 5.02944 1 10ZM9.5 12.2V3.7H10.7V12.2H9.5ZM10.6 16.3V14.5H9.4V16.3H10.6Z" fill="#995C00"/>
                    </svg>
                    <span>Il codice QR non &egrave; pi&ugrave; valido</span>
                </p>
                <#if oid4vpCancelUrl?has_content>
                    <a class="oid4vp-cancel-link"
                       href="${oid4vpCancelUrl}">
                        Annulla
                    </a>
                </#if>
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
