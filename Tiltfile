# local('tilt up --file=Tiltfile.gloo --hud=0 --port=0 >/dev/null 2>&1 &')

yaml = helm('./charts/tidepool', values=['./overrides.yaml'])

k8s_yaml(yaml)
