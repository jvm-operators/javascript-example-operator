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