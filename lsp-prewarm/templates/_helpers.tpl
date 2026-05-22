{{/* prewarm helpers */}}
{{- define "prewarm.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
