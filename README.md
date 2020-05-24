# Goland Remote Builder (dlv) for Kubernetes Pod Environment

## Why I need this?

In general, we debug goland application in IDE, such as goland. But when application is deployed to kubernetes pod, it is very hard to debug because pod environment is not same to local development IDE. For example, kube2iam or kiam, service discovery environment variables settings are already exists in pod, but it is difficult to reproduce the same conditions in local IDE.

For these reasons, It is better to debug goland application in kubernetes pod! Fortunately, delve package supports this feature.

## Image Type

- slim : install essential packages (recommended)
- full : install essential packages + golang vim devel plugins (e.g YouCompleteMe)

## How to use

```bash
$ kubectl apply -f kube-deployment.yaml
```

## Example: Let's debugging prometheus in Kubernetes Pod!

1. In local macos terminal, clone prometheus repository.

```
$ go get github.com/prometheus/prometheus
```

2. Enter to kubernetes pod, and clone prometheus repository. It is possible to sync local source codes into pod, but it is very time consuming. So I recommend to prepare same codes in pod.

```
$ kubectl exec -it $(kubectl get po -l='app=kubernetes-dev' --no-headers | awk '{print $1}') bash
$ go get github.com/prometheus/prometheus
```

3. Open two terminal and execute commands respectively.

```bash
$ kubectl port-forward $(kubectl get po -l='app=kubernetes-dev' --no-headers | awk '{print $1}') 22222:22
$ kubectl port-forward $(kubectl get po -l='app=kubernetes-dev' --no-headers | awk '{print $1}') 2345:2345
```

4. Open goland IDE, and open prometheus directory. After that, click [Tools] - [Deployment] - [Configuration], and add SFTP. 

5. Enter [Host] -> localhost, [port] -> 22222, [User Name] -> root, [Password] -> theoryofhappiness. If you click [Test connection]. goland will ask [yes/no]. In [Root Path], fill "/root/go/src/github.com/prometheus/prometheus"

6. In [Mappings] tab, fill [Deployment Path] to "/" (except quote). And finally click [OK]. 

7. Enable [Deployment] - [automatic upload].

8. Click [Add configuration] - [+] - [Go Remote], and [OK].

9. In terminal you exec into pod (step 2), go to prometheus main function.

```bash
$ cd ~/go/src/github.com/prometheus/prometheus/cmd/prometheus/
```

10. Finally, start dlv in Pod. Add breakpoints, click [Debug] in goland! Because prometheus.yml file does not exist in pod, prometheus will fail, maybe :D

```bash
$ dlv debug --headless --listen=:2345 --api-version=2 --accept-multiclient -- --storage.tsdb.max-block-duration=2m --storage.tsdb.min-block-duration=1m --storage.tsdb.retention=20m
```
