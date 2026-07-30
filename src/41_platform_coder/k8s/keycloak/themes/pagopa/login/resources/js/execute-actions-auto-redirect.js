const redirectContainer = document.querySelector(
  "[data-execute-actions-auto-redirect]",
);

if (redirectContainer) {
  const actionLink = document.querySelector(
    "a[data-execute-actions-target]",
  );
  const configuredDelay = Number.parseInt(
    redirectContainer.dataset.redirectDelay ?? "",
    10,
  );
  const redirectDelay = Number.isFinite(configuredDelay)
    ? configuredDelay
    : 800;

  if (actionLink) {
    window.setTimeout(() => {
      window.location.replace(actionLink.href);
    }, redirectDelay);
  }
}
