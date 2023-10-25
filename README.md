# ARCv2Demo

ARC v2 is a new version of the great Actions Runner Controller community project

Learn more in this great [video](https://www.youtube.com/watch?v=_F5ocPrv6io) from Bassem

<img width="1179" alt="image" src="https://github.com/gitstua-labs/ARCv2Demo/assets/25424433/39f06e5f-59ee-4893-84c3-f585553d6895">

Link to [preview v2 docs](https://github.com/actions/actions-runner-controller/blob/master/docs/preview/gha-runner-scale-set-controller/README.md)

Also see my Mindmap of ARC v2 https://github.com/gitstua/Mindmaps/blob/main/GitHub-ARC-v2-mindmap.md

## you can create an ARC v2 cluster inside GitHub Codespaces to get familiar with the steps
1. Create a new Codespace which has Docker, Helm2, KubeCtl already installed
2. Create a Kubernetes cluster
3. Generate either a personal access token (classic) or GitHub App credentials
4. Generate a config file for the Controller
5. Generate a config file for the Controller ScaleSet - this is the listener that creates the ephemeral runners

# Using this repo
1. Create a PAT TOKEN and give this the [correct permissions](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/authenticating-to-the-github-api#authenticating-arc-with-a-personal-access-token-classic)
2. Ensure you add the PAT TOKEN as a codespace secret for the repo 
2. Edit the script `./deploy-controller.sh` and set the `GITHUB_CONFIG_URL`
3. Use the script `./deploy-controller.sh` to run the setup of a controller and 2 scale sets

To reset the minikube and allow re-deployment you can use `./script/reset-demo.sh`


