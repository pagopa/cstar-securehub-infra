{{/* SPDX-License-Identifier: Apache-2.0 */}}
{{/* Keep names and selectors compatible with the existing HelmForge release. */}}
{{- define "listmonk.fullname" -}}listmonk{{- end -}}

{{- define "listmonk.selectorLabels" -}}
app.kubernetes.io/name: listmonk
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "listmonk.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote }}
{{ include "listmonk.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: helmforge
{{- end -}}

{{- define "listmonk.image" -}}
{{ printf "%s:%s" (required "image.repository is required" .Values.image.repository) (required "image.tag is required" .Values.image.tag) }}
{{- end -}}

{{- define "listmonk.appEnv" -}}
- name: LISTMONK_app__address
  value: {{ printf "0.0.0.0:%v" .Values.listmonk.port | quote }}
- name: LISTMONK_db__host
  value: {{ required "database.external.host is required" .Values.database.external.host | quote }}
- name: LISTMONK_db__port
  value: {{ .Values.database.external.port | quote }}
- name: LISTMONK_db__database
  value: {{ .Values.database.external.name | quote }}
- name: LISTMONK_db__user
  value: {{ .Values.database.external.username | quote }}
- name: LISTMONK_db__password
  valueFrom:
    secretKeyRef:
      name: {{ .Values.database.external.existingSecret }}
      key: {{ .Values.database.external.existingSecretPasswordKey }}
- name: LISTMONK_db__ssl_mode
  value: {{ .Values.database.external.sslMode | quote }}
{{- end -}}
