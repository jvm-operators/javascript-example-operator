FROM fabric8/java-centos-openjdk8-jdk:1.5.1

ENV JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=2 -XshowSettings:vm"

LABEL BASE_IMAGE="fabric8/java-centos-openjdk8-jdk:1.5.1"

COPY spark-operator-*.jar /spark-operator.jar
COPY common.js example.js /

CMD ["/usr/bin/jrunscript", "-cp", "/spark-operator.jar", "-f", "example.js"]