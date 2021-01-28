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

{{- define "charts.kafka.common" -}}
        - name: KAFKA_BROKERS
          valueFrom:
            configMapKeyRef:
              name: {{ .Values.kafka.configmapName }}
              key: Brokers
              optional: true
        - name: KAFKA_TOPIC_PREFIX
          valueFrom:
            configMapKeyRef:
              name: {{ .Values.kafka.configmapName }}
              key: TopicPrefix
              optional: true
        - name: KAFKA_REQUIRE_SSL
          valueFrom:
            configMapKeyRef:
              name: {{ .Values.kafka.configmapName }}
              key: RequireSSL
              optional: true
        - name: KAFKA_USERNAME
          valueFrom:
            configMapKeyRef:
              name: {{ .Values.kafka.configmapName }}
              key: Username
              optional: true
        - name: KAFKA_PASSWORD
          valueFrom:
            secretKeyRef:
              name: {{ .Values.kafka.secretName }}
              key: Password
              optional: true
        - name: KAFKA_VERSION
          valueFrom:
            configMapKeyRef:
              name: {{ .Values.kafka.configmapName }}
              key: Version
              optional: true
{{ end }}
