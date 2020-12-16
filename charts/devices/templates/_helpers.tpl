{{- define "charts.name" -}}
{{- default .Chart.Name .Values.global.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "charts.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "charts.labels.standard" }} 
    helm.sh/chart: {{ include "charts.chart" . }}
    app.kubernetes.io/managed-by: {{ .Release.Service }}
    app.kubernetes.io/name: {{ include "charts.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{ define "charts.tracing.common" }}
        - name: POD_NAME
          valueFrom:
              fieldRef:
                fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
              fieldRef:
                fieldPath: metadata.namespace
        - name: POD_IP
          valueFrom:
              fieldRef:
                fieldPath: status.podIP
        - name: OC_AGENT_HOST
          value: "oc-collector.tracing:55678"
        - name: OTEL_COLLECTOR_HOST
          value: "otel-collector.observability:55680"
{{ end }}

{{ define "charts.platform.env.misc" }}
{{ include "charts.tracing.common" . }}
        - name: AWS_REGION
          value: {{ .Values.global.region }}
        - name: TIDEPOOL_ENV
          value: local
        - name: TIDEPOOL_LOGGER_LEVEL
          value: {{ .Values.global.logLevel }}
        - name: TIDEPOOL_SERVER_TLS
          value: "false"
        - name: TIDEPOOL_AUTH_SERVICE_SECRET
          valueFrom:
            secretKeyRef:
              name: auth
              key: ServiceAuth
{{ end }}

{{- define "charts.platform.grpc_probes" -}}
        livenessProbe:
          exec:
            command: ["/bin/grpc_health_probe", "-addr=:{{.}}"]
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 5
        readinessProbe:
          exec:
            command: ["/bin/grpc_health_probe", "-addr=:{{.}}"]
          initialDelaySeconds: 5
          periodSeconds: 10
          timeoutSeconds: 5
{{- end -}}