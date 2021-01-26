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
    'keycloak',
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

globalValuesPath = './values/_global.yaml'

ghp_token = os.environ.get("GHP_TOKEN")

if not ghp_token:
    msg = ("Please make sure to set the 'GHP_TOKEN' environment variable. Some of the services (e.g., Seagull) " +
            "need it when using the local development image (building from the repo).")
    fail(msg)

docker_build('tidepool-seagull-dev', '../../LineTidepool/tidepool-seagull', 
    target='development', 
    build_args={ 
        'GHP_TOKEN': ghp_token
    })
docker_build('tidepool-shoreline-dev', '../../LineTidepool/tidepool-shoreline', target='development')
docker_build('tidepool-blip-dev', '../../LineTidepool/tidepool-blip', target='development')

def runHelmChart(chartName):
    values = []
    chartPath = "./charts/{chartName}".format(chartName=chartName)
    chartValuesPath = "./values/{chartName}.yaml".format(chartName=chartName)
    chartValuesLocalPath = "./values_local/{chartName}.yaml".format(chartName=chartName)

    valuesFileExists = read_yaml(chartValuesPath, False)
    valuesLocalFileExists = read_yaml(chartValuesLocalPath, False)

    if valuesFileExists:
        values.append(chartValuesPath)
    
    if valuesLocalFileExists:
        values.append(chartValuesLocalPath)

    values.append(globalValuesPath)

    yaml = helm(chartPath, values=values)
    k8s_yaml(yaml)

for chart in charts:
    runHelmChart(chart)
