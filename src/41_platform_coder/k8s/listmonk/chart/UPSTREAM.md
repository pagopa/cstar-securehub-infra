# Provenienza della chart minima

Derivazione della chart HelmForge **listmonk 1.2.3**, archivio esaminato il 4 novembre 2026:
[archivio upstream](https://repo.helmforge.dev/listmonk-1.2.3.tgz).

SHA-256: `3117b05edfff17fb614c4d3c55b7280b42ee68013987d751d7ce1f7ccfea3ad0`.
Licenza Apache-2.0 inclusa. L'hash identifica i byte esaminati; la firma upstream non è stata verificata. Questa variante non eredita attestazioni GPG/cosign dell'upstream.

Versione locale `1.2.3-pagopa.1`, immagine configurata da Terraform, revisione della chart fissata dall'Application Git. Non è stata pubblicata o deployata durante il task.

## Perché locale e perché ridotta

Recreate controlla il rollout; l'init settings configura OIDC/SMTP nel DB prima del server. Un plugin Argo riguarderebbe invece il rendering: dovrebbe comunque produrre manifest che realizzino quei comportamenti.

La 1.2.3 non espone questi adattamenti nei values e l'Application Helm standard non esegue il post-renderer Terraform. Si sceglie il derivato minimo per usare Argo standard, accettando la manutenzione locale. Un plugin già gestito dalla piattaforma o una futura chart con i parametri necessari permetterebbero di rivalutare la scelta. Restano soltanto:

- `deployment.yaml`: singolo worker, Recreate, init wait → install/upgrade → settings;
- `service.yaml`, `ingress.yaml`, `pvc.yaml`: routing e storage compatibili con la release originale;
- `_helpers.tpl`: nomi/selector, label, immagine e variabili DB condivise.

Il 5 novembre è stata eliminata la precedente copia completa: nessun template backup, External Secrets, Gateway API, extra manifests, Secret generato, ServiceAccount o NOTES. Nessuno schema JSON generico o catalogo di feature disabilitate. I default contengono solo campi usati; probes sono normali oggetti Kubernetes. Le verifiche essenziali risiedono nel Deployment.

Nomi `listmonk`/`listmonk-uploads` e selector restano compatibili con HelmForge. Non rinominare la release in Argo. `service.yaml` e `ingress.yaml` conservano i template upstream; il PVC è sempre persistente e il Deployment usa il ServiceAccount default senza token montato. Secret e ConfigMap sono prerequisiti esterni alla chart, gestiti da Terraform o dal workflow protetto SMTP. Nessuna credenziale in values/manifests, nessuna dipendenza PostgreSQL embedded.

OIDC e SMTP sono impostazioni DB: `settings.sql` resta nel bootstrap Terraform. SMTP usa un Secret dedicato soltanto nell'init settings, TLS 465 e metadati SES centralizzati; default disabilitato. Il log dello username nella Listmonk 6.2.0 è un rischio da risolvere prima dell'abilitazione, documentato in ADR-008; nessun checkbox Terraform viene spacciato per verifica tecnica.

## Aggiornamenti e verifica

Valutare la release upstream precisa, verificare provenienza/firma, confrontare i quattro manifest e aggiornare esplicitamente il derivato minimo solo quando necessario. Non reimportare l'intera chart. Non eseguire helm dependency update: non ci sono subchart.

Dalla root, `python -B scripts/validate_listmonk.py --helm <Helm3>` esegue lint/render offline per i tre ambienti, SMTP ON/OFF e invarianti. L'opzione `--upstream <directory-1.2.3-estratta>` confronta nomi/spec di Service, Ingress e PVC e selector del Deployment. I default da soli sono intenzionalmente incompleti: usare i values generati da Terraform. Vedere docs/LISTMONK_AKS_DEPLOYMENT_ANALYSIS.md per handoff e verifiche live autorizzate.
