export SYSTEM_NAMESPACE=arc-system
export INSTALLATION_NAME=arc-runner-set
export RUNNER_NAMESPACE="arc-runner"
export GITHUB_CONFIG_URL="https://github.com/gitstua-labs"

echo Start minikube
minikube -h
minikube start -p arc --cpus=4 --memory=8192 --mount-string="/run/udev:/run/udev" --mount
minikube status -p arc

echo creating namespace $SYSTEM_NAMESPACE
kubectl create namespace $SYSTEM_NAMESPACE

echo installing Controller
helm install arc \
    --namespace $SYSTEM_NAMESPACE \
    --set image.tag="0.4.0" \
    --set githubConfigSecret.github_token="$WITH_PAT_TOKEN" \
    -f ./values-controller.yaml \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller \
    --version "0.4.0"

count=0

read -t 5 -p "I am going to wait for 5 seconds only ..."

echo wait for controller pod to be ready
while true; do
    POD_NAME=$(kubectl get pods -n $SYSTEM_NAMESPACE -l app.kubernetes.io/name=gha-runner-scale-set-controller -o name)
    if [ -n "$POD_NAME" ]; then
        echo "Pod found: $POD_NAME"
        break
    fi
    if [ "$count" -ge 120 ]; then
        echo "Timeout waiting for controller pod with label app.kubernetes.io/name=gha-runner-scale-set-controller"
        exit 1
    fi
    sleep 2
    count=$((count+1))
done

echo wait for pod to be ready
kubectl wait --timeout=30s --for=condition=ready pod -n $SYSTEM_NAMESPACE -l app.kubernetes.io/name=gha-runner-scale-set-controller
kubectl get pod -n $SYSTEM_NAMESPACE
# kubectl describe deployment gha-runner-scale-set-controller -n $SYSTEM_NAMESPACE

echo creating namespace $RUNNER_NAMESPACE
kubectl create namespace $RUNNER_NAMESPACE


helm install "${INSTALLATION_NAME}1" \
    --namespace $RUNNER_NAMESPACE \
    --set image.tag="0.4.0" \
    --set runnerGroup="grp-scale-set1" \
    --set githubConfigUrl="${GITHUB_CONFIG_URL}" \
    --set githubConfigSecret.github_token="$WITH_PAT_TOKEN" \
    -f ./values-scaleset.yaml \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set \
    --version "0.4.0"

helm install "${INSTALLATION_NAME}2" \
    --namespace $RUNNER_NAMESPACE \
    --set image.tag="0.4.0" \
    --set runnerGroup="grp-scale-set2" \
    --set githubConfigUrl="${GITHUB_CONFIG_URL}" \
    --set githubConfigSecret.github_token="$WITH_PAT_TOKEN" \
    -f ./values-scaleset.yaml \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set \
    --version "0.4.0"
