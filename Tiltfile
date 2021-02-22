load('./lib/Tiltfile.helpers', 'runHelmChart')

charts = [
    'auth',
    'blip',
    'blob',
    'configmaps',
    'data',
    'devices',
    'export',
    'gatekeeper',
    'gloo',
    'highwater',
    'hydrophone',
    'jellyfish',
    'kafka',
    'messageapi',
    'migrations',
    'mongo',
    'prescription',
    'seagull',
    'secrets',
    'shoreline',
    'task',
    'tidewhisperer',
    'tools',
    'zookeeper'
]

ghp_token = os.environ.get("GHP_TOKEN")

if not ghp_token:
    msg = ("Please make sure to set the 'GHP_TOKEN' environment variable. Some of the services (e.g., Seagull) " +
            "need it when using the local development image (building from the repo).")
    fail(msg)

docker_build('tidepool-jellyfish-dev', '../tidepool-jellyfish', target='development', 
    live_update=[
        sync('../tidepool-jellyfish/lib', '/app/lib'),
        sync('../tidepool-jellyfish/app.js', '/app/app.js')
    ])
docker_build('tidepool-shoreline-dev', '../tidepool-shoreline', target='development')
docker_build('tidepool-seagull-dev', '../tidepool-seagull', 
    target='development', 
    build_args={ 
        'GHP_TOKEN': ghp_token
    })
docker_build('tidepool-blip-dev', '../tidepool-blip', target='development', 
    live_update=[sync('../tidepool-blip/app', '/app/app')],
    build_args={ 
        'GHP_TOKEN': ghp_token
    })

for chart in charts:
    runHelmChart(chart)
