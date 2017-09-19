# Pre-requisites
```sh
git clone $PUPPET_REPO # sad
git clone $HIERA_REPO  # panda
```
Note: Unfortunately intenral puppet/hiera code. Aliases come from my env vars. Ensure whatever names you have for your hieradata and puppet-code you also add them in the .gitignore if they should not be out in the wild!

# Build
Follows up from [sandy-k8s-registry/README.md](https://github.com/Klazomenai/sandy-k8s-registry).
 - Use Docker from within Minikube
```sh
eval $(minikube docker-env)
```

 - Build new Centos Docker image from the Dockerfile in thie repo
```sh
docker build . --tag=registry:5000/puppetserver:latest
```

 - Push newly build image to local Docker registry
```sh
docker push registry:5000/puppetserver:latest
```

 - Create new instance
```sh
kubectl create -f puppetserver.yaml
```

Note: Puppetserver port 8140 needs to be visible from the host once puppetserver container is running. The port takes a while to come up. Nc, telnet, nmap...

