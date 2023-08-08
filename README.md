# ARCv2Demo

ARC v2 is a new version of the great Actions Runner Controller community project

Learn more in this great [video](https://www.youtube.com/watch?v=_F5ocPrv6io)https://www.youtube.com/watch?v=_F5ocPrv6io

![image](https://github.com/gitstua-labs/ARCv2Demo/assets/25424433/b3e266a2-6b58-4f4d-bf42-a612a0a906bd)


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
help version
minikube start -p arc --cpus=4 --memory=8192 --mount-string="/run/udev:/run/udev" --mount
minikibe status -p arc
# configure the values.yaml file for helm chart for controller https://raw.githubusercontent.com/actions/actions-runner-controller/master/charts/gha-runner-scale-set-controller/values.yaml

# configure the values.yaml file for helm chart for controller SCALESET https://raw.githubusercontent.com/actions/actions-runner-controller/master/charts/gha-runner-scale-set/values.yaml 

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

```