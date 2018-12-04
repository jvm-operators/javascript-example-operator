IMAGE?=radanalyticsio/javascript-example-operator

.PHONY: install-jar
install-jar:
	rm -rf ./spark-operator ; git clone --depth=1 --branch master https://github.com/radanalyticsio/spark-operator.git && cd spark-operator && MAVEN_OPTS="-Djansi.passthrough=true -Dplexus.logger.type=ansi $(MAVEN_OPTS)" ./mvnw package -DskipTests && cp target/spark-operator-*.jar .. && cd - && rm -rf ./spark-operator

.PHONY: build
build: install-jar
	docker build -t $(IMAGE):latest -f Dockerfile .

.PHONY: devel
devel: build
	-docker kill `docker ps -q` || true
	oc cluster up
	oc apply -f manifest/operator.yaml
	until [ "true" = "`oc get pod -l app.kubernetes.io/name=javascript-example-operator -o json 2> /dev/null | grep \"\\\"ready\\\": \" | sed -e 's;.*\(true\|false\),;\1;'`" ]; do printf "."; sleep 1; done
	oc logs -f `oc get pods --no-headers -l app.kubernetes.io/name=javascript-example-operator | cut -f1 -d' '`

.PHONY: devel-kubernetes
devel-kubernetes:
	-minikube delete
	minikube start --vm-driver kvm2
	eval `minikube docker-env` && $(MAKE) build
	kubectl apply -f manifest/operator.yaml
	until [ "true" = "`kubectl get pod -l app.kubernetes.io/name=javascript-example-operator -o json 2> /dev/null | grep \"\\\"ready\\\": \" | sed -e 's;.*\(true\|false\),;\1;'`" ]; do printf "."; sleep 1; done
	kubectl logs -f `kubectl get pods --no-headers -l app.kubernetes.io/name=javascript-example-operator | cut -f1 -d' '`