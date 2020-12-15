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