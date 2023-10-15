# ARCv2Demo

ARC v2 is a new version of the great Actions Runner Controller community project

Learn more in this great [video](https://www.youtube.com/watch?v=_F5ocPrv6io) from Bassem

<img width="1179" alt="image" src="https://github.com/gitstua-labs/ARCv2Demo/assets/25424433/39f06e5f-59ee-4893-84c3-f585553d6895">

Link to [preview v2 docs](https://github.com/actions/actions-runner-controller/blob/master/docs/preview/gha-runner-scale-set-controller/README.md)

Also see my Mindmap of ARC v2 https://github.com/gitstua/Mindmaps/blob/main/GitHub-ARC-v2-mindmap.md

## you can create an ARC v2 cluster inside GitHub Codespaces to get familiar
1. Create a new Codespace which has Docker, Helm2, KubeCtl already installed
2. Create a Kubernetes cluster
3. Generate either a PAT token or GitHub App credentials
4. Generate a config file for the Controller
5. Generate a config file for the Controller ScaleSet - this is the listener that creates the ephemeral runners


## Commands to setup cluster
```
minikube -h
minikube start -p arc --cpus=4 --memory=8192 --mount-string="/run/udev:/run/udev" --mount
minikibe status -p arc

# configure the values.yaml file for helm chart for controller https://raw.githubusercontent.com/actions/actions-runner-controller/master/charts/gha-runner-scale-set-controller/values.yaml

# configure the values.yaml file for helm chart for controller SCALESET https://raw.githubusercontent.com/actions/actions-runner-controller/master/charts/gha-runner-scale-set/values.yaml 

# setup some environment variables


#install the controller
helm install arc \
--namespace arc-systems \
--create-namespace \
--set image.tag="0.4.0" \
-f ./values-controller.yaml \
oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller \
--version "0.4.0"

helm list -A
kubectl get pods -n arc-systems
#  kubectl logs pod/arc-gha-runner-scale-set-controller-755f574df6-bnrq8 -n arc-systems

# Using a GitHub App
INSTALLATION_NAME="arc-runner-set"
NAMESPACE="arc-runners"
GITHUB_CONFIG_URL="https://github.com/gitstua-labs"
GITHUB_APP_ID="372949"
GITHUB_APP_INSTALLATION_ID="40496144"
# GITHUB_APP_PRIVATE_KEY="<GITHUB_APP_PRIVATE_KEY>"

# we can pass the private key to a codespace using a codespace secret
GITHUB_APP_PRIVATE_KEY=$APP_PRIVATE_KEY

# add first runner scale set
helm install "${INSTALLATION_NAME}" \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    --set runnerGroup="default" \
    --set githubConfigUrl="${GITHUB_CONFIG_URL}" \
    --set githubConfigSecret.github_app_id="${GITHUB_APP_ID}" \
    --set githubConfigSecret.github_app_installation_id="${GITHUB_APP_INSTALLATION_ID}" \
    --set githubConfigSecret.github_app_private_key="${GITHUB_APP_PRIVATE_KEY}" \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set

kubectl get pods -A

# add a second runner scale set to a runner group named grp-scale-set2
helm install "${INSTALLATION_NAME}2" \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    --set runnerGroup="grp-scale-set2" \
    --set githubConfigUrl="${GITHUB_CONFIG_URL}" \
    --set githubConfigSecret.github_app_id="${GITHUB_APP_ID}" \
    --set githubConfigSecret.github_app_installation_id="${GITHUB_APP_INSTALLATION_ID}" \
    --set githubConfigSecret.github_app_private_key="${GITHUB_APP_PRIVATE_KEY}" \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set

kubectl get pods -A
```
