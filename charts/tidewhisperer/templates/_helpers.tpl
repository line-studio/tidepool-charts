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

{{- define "charts.init.shoreline" -}}
      - name: init-shoreline
        image: busybox:1.31.1
        command: ['sh', '-c', 'until nc -zvv shoreline {{.Values.global.ports.shoreline}}; do echo waiting for shoreline; sleep 2; done;']
{{- end -}} 

{{ define "charts.mongo.params" }}
        - name: TIDEPOOL_STORE_SCHEME
          valueFrom:
            secretKeyRef:
              name: {{ .Values.mongo.secretName }}
              key: Scheme
        - name: TIDEPOOL_STORE_USERNAME
          valueFrom:
            secretKeyRef:
              name: {{ .Values.mongo.secretName }}
              key: Username
        - name: TIDEPOOL_STORE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: {{ .Values.mongo.secretName }}
              key: Password
              optional: true
        - name: TIDEPOOL_STORE_ADDRESSES
          valueFrom:
            secretKeyRef:
              name: {{ .Values.mongo.secretName }}
              key: Addresses
        - name: TIDEPOOL_STORE_OPT_PARAMS
          valueFrom:
            secretKeyRef:
              name: {{ .Values.mongo.secretName }}
              key: OptParams
        - name: TIDEPOOL_STORE_TLS
          valueFrom:
            secretKeyRef:
              name: {{ .Values.mongo.secretName }}
              key: Tls
{{ end }}

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
