charts = [
    'auth',
    'blip',
    'configmaps',
    'gatekeeper',
    'gloo',
    'kafka',
    'secrets',
    'shoreline',
    'tools',
    'zookeeper'
]

globalValuesPath = './values/_global.yaml'

def runHelmChart(chartName):
    values = []
    chartPath = "./charts/{chartName}".format(chartName=chartName)
    chartValuesPath = "./values/{chartName}.yaml".format(chartName=chartName)

    valuesFileExists = read_yaml(chartValuesPath, False)

    if valuesFileExists:
        values.append(chartValuesPath)

    values.append(globalValuesPath)

    yaml = helm(chartPath, values=values)
    k8s_yaml(yaml)

for chart in charts:
    runHelmChart(chart)