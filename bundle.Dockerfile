FROM scratch

LABEL operators.operatorframework.io.bundle.mediatype.v1=registry+v1
LABEL operators.operatorframework.io.bundle.manifests.v1=manifests/
LABEL operators.operatorframework.io.bundle.metadata.v1=metadata/
LABEL operators.operatorframework.io.bundle.package.v1=seldon-deploy-operator
LABEL operators.operatorframework.io.bundle.channels.v1=stable,alpha
LABEL operators.operatorframework.io.bundle.channel.default.v1=stable
LABEL operators.operatorframework.io.metrics.builder=operator-sdk-v1.2.0
LABEL operators.operatorframework.io.metrics.mediatype.v1=metrics+v1
LABEL operators.operatorframework.io.metrics.project_layout=helm.sdk.operatorframework.io/v1
LABEL operators.operatorframework.io.test.config.v1=tests/scorecard/
LABEL operators.operatorframework.io.test.mediatype.v1=scorecard+v1

LABEL com.redhat.openshift.versions="v4.3,v4.4,v4.5,v4.6,v4.7"
LABEL com.redhat.delivery.operator.bundle=true
LABEL com.redhat.delivery.backport=true

COPY bundle/manifests /manifests/
COPY bundle/metadata /metadata/
COPY bundle/tests/scorecard /tests/scorecard/
