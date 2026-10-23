document.addEventListener("DOMContentLoaded", function() {
    var storageKey = "oid4vp-browser-refresh";
    var config = document.getElementById("oid4vp-browser-refresh-config");
    try {
        var url = new URL(config ? config.dataset.refreshUrl : window.location.href, window.location.href);
        if (config) {
            window.history.replaceState(window.history.state, "", url.href);
        }
    } catch (error) {
        console.error("OID4VP: Failed to update browser refresh URL", error);
        return;
    }

    try {
        var clientId = url.searchParams.get("client_id");
        var clientData = url.searchParams.get("client_data");
        if (!clientId || !clientData) {
            return;
        }
        var sessionKey = url.origin + url.pathname + ":" + clientId + ":" + clientData;
        if (config) {
            window.sessionStorage.removeItem(storageKey);
            if (config.dataset.cancelUrl) {
                window.sessionStorage.setItem(storageKey, JSON.stringify({
                    sessionKey: sessionKey,
                    cancelUrl: new URL(config.dataset.cancelUrl, window.location.href).href
                }));
            }
            return;
        }
        if (document.body.dataset.pageId !== "login-login") {
            return;
        }
        var navigation = window.performance.getEntriesByType("navigation")[0];
        if (!navigation || navigation.type !== "reload"
            || document.querySelector('#kc-form-login [aria-invalid="true"]')) {
            window.sessionStorage.removeItem(storageKey);
            return;
        }
        var context;
        try {
            context = JSON.parse(window.sessionStorage.getItem(storageKey));
        } catch (error) {
            window.sessionStorage.removeItem(storageKey);
            throw error;
        }
        if (!context || context.sessionKey !== sessionKey) {
            return;
        }
        var storedCancelUrl = new URL(context.cancelUrl);
        if (storedCancelUrl.protocol === "https:" || storedCancelUrl.protocol === "http:") {
            window.sessionStorage.removeItem(storageKey);
            window.location.replace(storedCancelUrl.href);
        }
    } catch (error) {
        console.error("OID4VP: Failed to handle browser refresh context", error);
    }
}, { once: true });