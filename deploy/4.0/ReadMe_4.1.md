Пример настройки и развёртывания системы мониторинга используя kube-prometheus.

*Доступ непосредственно к web-интерфейсу prometheus будет реализован при развёртывании приложения на следующих шагах, приведённые данные в данном файле лишь демонстрируют ход предварительного развёртывания и проверки.


# Create the namespace and CRDs, and then wait for them to be available before creating the remaining resources
# Note that due to some CRD size we are using kubectl server-side apply feature which is generally available since kubernetes 1.22.
# If you are using previous kubernetes versions this feature may not be available and you would need to use kubectl create instead.
kubectl apply --server-side -f manifests/setup
kubectl wait \
    --for condition=Established \
    --all CustomResourceDefinition \
    --namespace=monitoring
kubectl apply -f manifests/

# Access UIs

Prometheus, Grafana, and Alertmanager dashboards can be accessed quickly using `kubectl port-forward` after running the quickstart via the commands below. Kubernetes 1.10 or later is required.

> Note: There are instructions on how to route to these pods behind an ingress controller in the [Exposing Prometheus/Alermanager/Grafana via Ingress](customizations/exposing-prometheus-alertmanager-grafana-ingress.md) section.

## Prometheus

```shell
$ kubectl --namespace monitoring port-forward svc/prometheus-k8s 9090
```

Then access via [http://localhost:9090](http://localhost:9090)

## Grafana

```shell
$ kubectl --namespace monitoring port-forward svc/grafana 3000
```

Then access via [http://localhost:3000](http://localhost:3000) and use the default grafana user:password of `admin:admin`.

## Alert Manager

```shell
$ kubectl --namespace monitoring port-forward svc/alertmanager-main 9093
```

Then access via [http://localhost:9093](http://localhost:9093)


# Ход развёртывания:

```
iva@c9v:~/Documents/Diplom/4.0 $ git clone https://github.com/prometheus-operator/kube-prometheus.git
iva@c9v:~/Documents/Diplom/4.0/kube-prometheus  (main)$ kubectl wait \
        --for condition=Established \
        --all CustomResourceDefinition \
        --namespace=monitoring
iva@c9v:~/Documents/Diplom/4.0/kube-prometheus  (main)$ kubectl apply -f manifests/

iva@c9v:~/Documents/Diplom/4.0/kube-prometheus  (main)$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
<cut>...</cut>
monitoring    alertmanager-main-0                        2/2     Running   0          115s
monitoring    alertmanager-main-1                        2/2     Running   0          115s
monitoring    alertmanager-main-2                        2/2     Running   0          115s
monitoring    blackbox-exporter-6fd586b445-tcmg8         3/3     Running   0          2m29s
monitoring    grafana-9f58f8675-9p24g                    1/1     Running   0          2m18s
monitoring    kube-state-metrics-66659c89c-jl9nt         3/3     Running   0          2m16s
monitoring    node-exporter-92b6n                        2/2     Running   0          2m14s
monitoring    node-exporter-hjzzl                        2/2     Running   0          2m14s
monitoring    node-exporter-pc4q7                        2/2     Running   0          2m14s
monitoring    node-exporter-pxws2                        2/2     Running   0          2m14s
monitoring    prometheus-adapter-757f9b4cf9-msw97        1/1     Running   0          2m11s
monitoring    prometheus-adapter-757f9b4cf9-zw4bm        1/1     Running   0          2m11s
monitoring    prometheus-k8s-0                           2/2     Running   0          114s
monitoring    prometheus-k8s-1                           2/2     Running   0          114s
monitoring    prometheus-operator-776c6c6b87-xhdpn       2/2     Running   0          2m11s

```

После развёртывания необходимо удалить одно из правил создаваемое по умолчанию препятствующее доступу из вне к grafana

```
$ kubectl -n monitoring delete networkpolicies.networking.k8s.io grafana
```

опубликовать графану наружу:

```
$ kubectl apply -f ingress.yaml -f service.yaml 

```