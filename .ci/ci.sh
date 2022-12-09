

echo "### BUILD_NUMBER = $BUILD_NUMBER"
export JAVA_HOME="/Users/B7W/Library/Java/JavaVirtualMachines/temurin-17.0.2/Contents/Home"
echo "### Setting JAVA_HOME = $JAVA_HOME"


echo "### Start maven"
echo "BUILD_NUMBER=$BUILD_NUMBER" > src/main/resources/static/version.txt
echo "GIT_HASH=$(git rev-parse HEAD)" >> src/main/resources/static/version.txt
mvn clean package
rm src/main/resources/static/version.txt
echo "### EOF maven"


echo "### Start docker build"
mkdir -p .ci/target
mv target/kube-0.0.1-SNAPSHOT.jar .ci/target/kube.jar
eval $(minikube -p minikube docker-env)
docker build .ci/ -t kube:latest
echo "### EOF docker build"


echo "### Start deploy"
jinja2 .ci/deployment.yml .ci/vars.st1.yml > .ci/target/deployment.st1.yml
kubectl apply -f .ci/target/deployment.st1.yml
kubectl rollout status deployment/kube-st1
echo "### EOF deploy"
