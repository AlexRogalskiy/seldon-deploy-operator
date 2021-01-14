# Seldon Deploy Operator

This operator can be used for installing instances of Seldon Deploy. Built with operator-sdk.

## Building

To build and push just the operator:
```bash
make docker-build
make docker-push
```
To also build and push the bundle:
```bash
make update_openshift
```

## Testing

### KIND Full Deploy Stack

To test in KIND with entire stack:

* First run kind-setup.sh from seldon-deploy repo.
* Next run `make install`
* Then `make deploy`
* Then `kubectl apply -n seldon-system -f ./examples-testing/kind-full-setup.yaml`
* Then `make open_kind`

### KIND no dependencies

This is a minimal setup just for checking installation. No Deploy features work.

* `kind create cluster`
* `make install`
* `make deploy`
* `kubectl apply -n seldon-system -f ./examples-testing/kind-minimal-setup.yaml`
*  Port-forward to deploy to see UI, though you can't deploy anything in this setup.

### OLM Deployment

First need a cluster e.g. `kind create cluster`.

For KIND or other clusters without OLM, we [first install OLM](https://sdk.operatorframework.io/docs/olm-integration/quickstart-bundle/)

* Install OLM - `operator-sdk olm install` (tested with 0.17)

* Install marketplace - `make operator-marketplace`

Now [create](https://redhat-connect.gitbook.io/certified-operator-guide/ocp-deployment/operator-metadata/creating-the-metadata-bundle), push and [validate the bundle](https://redhat-connect.gitbook.io/certified-operator-guide/ocp-deployment/operator-metadata/creating-the-csv)

* All done in `make update_openshift`

Create a catalog_source

```bash
kubectl create -f tests/catalog-source.yaml
```

Check

```
kubectl get catalogsource seldon-deploy-catalog -n marketplace -o yaml
```

Create operator group

```bash
kubectl create -f tests/operator-group.yaml
```

Create Subscription

```bash
kubectl create -f tests/operator-subscription.yaml
```
Check the Subscription and CSV:
```bash
kubectl get subscriptions.operators.coreos.com -n marketplace seldon-deploy-operator-subsription -o yaml
kubectl get ClusterServiceVersion -n marketplace
```
Note here the operator will be namespace only ((OwnNamespace mode)[https://catalog.redhat.com/software/operators/detail/5f0f35842991b4207fcdb202/deploy]) so will only manage SeldonDeploy instances in marketplace namespace.

Now we create a deploy instance.

* `kubectl apply -n marketplace -f ./examples-testing/kind-minimal-setup.yaml` (or full if stack is present, see above)

If using the full stack then we can run demos. We'll need to apply a license, either in the UI or using `make apply_license`. Open with `make open_kind`

### Testing on OpenShift

Before testing a new version make sure `make update_openshift` has been run.

Create catalog source
```bash
kubectl create -f tests/catalog-source-openshift.yaml
```
Check
```bash
kubectl get catalogsource seldon-deploy-catalog -n openshift-marketplace -o yaml
```
Choose the operator in the UI. Be sure to get the right version.

If clusterwide then check with:
```bash
kubectl get subscriptions.operators.coreos.com -n openshift-operators seldon-deploy-operator -o yaml
```
Adjust namespace if not clusterwide.

Use [installation google doc](https://docs.google.com/document/d/1Z1mYh0ZlNWHypgqVD64y6rAq0Bz6WW_LFXc0D0Big74/edit?usp=sharing) for setting up dependencies or running minimal version.


TEST END TO END

CORE 1.5.0 LINKUP, SERVERLESS AND ECK ELASTIC WORKING NOW
WITH OPENSHIFT ELASTIC REQ LOGGER HIT https://github.com/openshift/elasticsearch-operator/issues/338
CHECK ARGO AND MINIO?

A NEWLY-STARTED BATCH JOB FAILS WITH pods "iris-rzh8l-2284698505" is forbidden: unable to validate against any security context constraint: [spec.volumes[1]: Invalid value: "hostPath": hostPath volumes are not allowed to be used]
MAYBE WE CAN GRANT TO THE SERVICE ACCOUNT? https://github.com/openshift/origin/issues/11153#issuecomment-302076227
THIS WORKS:

oc adm policy add-scc-to-user hostaccess system:serviceaccount:seldon:workflow

BUT THEN THE POD FOR THE WORKFLOW FAILS WITH
MountVolume.SetUp failed for volume "docker-sock" : hostPath type check failed: /var/run/docker.sock is not a socket file
SEE
https://github.com/argoproj/argo/issues/1788
https://github.com/argoproj/argo/issues/3500

UBI VERSIONS OF NEW IMAGES
SCRIPTS LIKE OLD openshift-full-setup ? IS IT WORTH IT AS THEY CHANGE ANYWAY?
NAMESPACED? SWITCH OFF THAT SETTING? OPERATOR ITSELF SHOULD WORK IN SINGLE NAMESPACE
AUTOMATE CREATION OF CERTIFIED?

### Scorecard

First have a bundle built. Then `make scorecard`

TODO: this fails. Do I have to use quay as seems it can't pull from dockerhub?

## Maintaining This Project

Each new release needs to be based on the latest seldon deploy helm chart. 

TODO: see previous version but makefile has all changed