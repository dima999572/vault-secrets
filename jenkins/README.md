# Jenkins Setup Guide

## 1. Create a Kubernetes Namespace

Create a Kubernetes namespace for Jenkins by running the following command:

```bash
kubectl create namespace jenkins
```

To verify that the resources are created in the jenkins namespace, run:

```bash
kubectl get all --namespace jenkins
```

## 2. Setup Helm Repository and Install Jenkins

### 2.1 Add the Jenkins Helm Repository

To add the Jenkins Helm repository, run:

```bash
helm repo add jenkins https://charts.jenkins.io
```

### 2.2 Verify Helm Chart Access

Check that you have access to the Jenkins chart by running:

```bash
helm search repo jenkins/jenkins
```

### 2.3 Install or Upgrade Jenkins using Helm

You can install or upgrade Jenkins using Helm. Optionally, you can run the command with the --dry-run flag to preview the generated manifests:

```bash
helm upgrade --install --create-namespace --namespace jenkins jenkins jenkins/jenkins
```

To view the generated manifests, use:

```bash
helm get manifest -n jenkins jenkins
```

## 3. Initialize Jenkins

### 3.1 Get 'admin' User Password

To retrieve the 'admin' user password, run the following command:

```bash
kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo
```

### 3.2 Access Jenkins UI

To access the Jenkins UI, set up port forwarding by running the following command:

```bash
kubectl --namespace jenkins port-forward svc/jenkins 8080:8080
```

### 3.3 Jenkins Configuration as Code

Use Jenkins Configuration as COde (JCasC) by specifying configScripts in your values.yaml file. For more information, vitsit the following links:

- [Jenkins Configuration as Code Documentation](http://127.0.0.1:8080/configuration-as-code)
- [JCasC Examples](https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos)

### 3.4 Additional Resources

For more information on running Jenkins on Kubernetes, visit:

- [Jenkins on Google Cloud](https://cloud.google.com/solutions/jenkins-on-container-engine)

For more information about Jenkins Configuration as Code, visit

- [Jenkins Configuratio as Code Project](https://jenkins.io/projects/jcasc/)
