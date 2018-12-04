# javascript-example-operator

[![Build status](https://travis-ci.org/jvm-operators/javascript-example-operator.svg?branch=master)](https://travis-ci.org/jvm-operators/javascript-example-operator)
[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)

`{ConfigMap|CRD}`-based approach for managing X in Kubernetes and OpenShift.

This operator uses [abstract-operator](https://github.com/jvm-operators/abstract-operator) library.

# Info
This project demonstrates the the JavaScript way to write the operators for K8s and OpenShift. It uses the Nashorn
JavaScript Engine in JDK. However, it requires also quite a lot of Java dependencies on the classpath, so that for the
sake of simplicity, we prepared a simple demo where it builds the existing Java operator and creates an uber jar that
is used as a simple form of passing all the needed dependencies. The handlers for the events (key parts)
are implemented in JavaScript.


[example.js](./example.js):
```javascript
load("common.js")

// on add handler
var onAdd = function(foo) {
  print("Hello from JavaScript, added " + foo.name);
};

// on delete handler
var onDelete = function(foo) {
  print("Hello from JavaScript, deleted " + foo.name);
};

// start the operator
startOperator(onAdd, onDelete);

// sleep 10 years
java.lang.Thread.sleep(1000 * 60 * 60 * 24 * 365 * 10);
```

[common.js](./common.js):
```javascript
function startOperator(onAdd, onDelete) {
    var DefaultKubernetesClient = Java.type("io.fabric8.kubernetes.client.DefaultKubernetesClient");
    var client = new DefaultKubernetesClient();

    var AbstractOperator = Java.type("io.radanalytics.operator.common.AbstractOperator");
    var MyOperator = Java.extend(AbstractOperator, { onAdd: onAdd, onDelete: onDelete });
    var op = new MyOperator();
    op.infoClass = Java.type("io.radanalytics.types.SparkCluster").class;
    op.namespace = "myproject"
    op.prefix = "radanalytics.io"
    op.client = client;
    op.isOpenshift = true;
    op.fullReconciliationRun = true;
    var future = op.start();
    return future;
}
```

# Usage

```bash
make devel-kubernetes # for K8s
```

```bash
make devel # for OpenShift
```

or even without deploying to K8s:
```bash
jrunscript -cp ./spark-operator-*.jar -f example.js
```

## Demo

```bash
kubectl apply -f ./manifest/operator.yaml
kubectl apply -f ./examples/cluster.yaml
```

meanwhile in the Kubernetes logs:
```bash
...
2018-12-04 14:53:31 INFO  AbstractOperator:419 - creating sparkcluster:  
my-spark-cluster
Hello from JavaScript, added my-spark-cluster
...
```
Notice that `Hello from JavaScript..` was declared above in the JavaScript code in the `onAdd()` method.


## Notes
Since we call the `start()` method on the operator directly, it lacks the periodical `full-reconciliation`
logic that is normally scheduled in the `Entrypoint.java`. 
