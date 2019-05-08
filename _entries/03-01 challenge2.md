---
sectionid: deploy
sectionclass: h2
title: Create a basic pipeline to validates a Terraform template
parent-id: upandrunning
---

Azure Pipelines is a service for implementing continus integration and deployment. Our first challenge will be to create a Pipeline which validates a Terraform template, as this will be the first step in our CI/CD process.


### Tasks


#### Create a project in Azure Devops

{% collapsible %}

Go to [https://dev.azure.com](https://dev.azure.com), sign in, and create a new project to work in for this challenge.

{% endcollapsible %}

#### Add your

{% collapsible %}

```sh
az group create --name akschallenge --location <region>
```

{% endcollapsible %}

####  Now you need to create the AKS cluster

> **Note** You can create AKS clusters that support the [cluster autoscaler](https://docs.microsoft.com/en-us/azure/aks/cluster-autoscaler#about-the-cluster-autoscaler). However, please note that the AKS cluster autoscaler is a preview feature, and enabling it is a more involved process. AKS preview features are self-service and opt-in. Previews are provided to gather feedback and bugs from our community. However, they are not supported by Azure technical support. If you create a cluster, or add these features to existing clusters, that cluster is unsupported until the feature is no longer in preview and graduates to general availability (GA).

##### **Option 1:** Create an AKS cluster without the cluster autoscaler

  {% collapsible %}

  Create AKS using the latest version and enable the monitoring addon

  ```sh
  az aks create --resource-group akschallenge \
    --name <unique-aks-cluster-name> \
    --location <region> \
    --enable-addons monitoring \
    --kubernetes-version $version \
    --generate-ssh-keys
  ```

  > **Important**: If you are using Service Principal authentication, for example in a lab environment, you'll need to use an alternate command to create the cluster with your existing Service Principal passing in the `Application Id` and the `Application Secret Key`.
  >
  > ```sh
  > az aks create --resource-group akschallenge \
  >   --name <unique-aks-cluster-name> \
  >   --location <region> \
  >   --enable-addons monitoring \
  >   --kubernetes-version $version \
  >   --generate-ssh-keys \
  >   --service-principal <application ID> \
  >   --client-secret "<application secret key>"
  > ```

  {% endcollapsible %}

##### **Option 2 (*Preview*):** Create an AKS cluster with the cluster autoscaler

  {% collapsible %}
 
  AKS clusters that support the cluster autoscaler must use virtual machine scale sets and run Kubernetes version *1.12.4* or later. This scale set support is in preview. To opt in and create clusters that use scale sets, first install the *aks-preview* Azure CLI extension using the `az extension add` command, as shown in the following example:

  ```sh
  az extension add --name aks-preview
  ```

  To create an AKS cluster that uses scale sets, you must also enable a feature flag on your subscription. To register the *VMSSPreview* feature flag, use the `az feature register` command as shown in the following example:

  ```sh
  az feature register --name VMSSPreview --namespace Microsoft.ContainerService
  ```

  It takes a few minutes for the status to show *Registered*. You can check on the registration status using the `az feature list` command:

  ```sh
  az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/VMSSPreview')].{Name:name,State:properties.state}"
  ```

  When ready, refresh the registration of the *Microsoft.ContainerService* resource provider using the `az provider register` command:

  ```sh
  az provider register --namespace Microsoft.ContainerService
  ```

  Use the `az aks create` command specifying the `--enable-cluster-autoscaler` parameter, and a node `--min-count` and `--max-count`.

  > **Note** During preview, you can't set a higher minimum node count than is currently set for the cluster. For example, if you currently have min count set to *1*, you can't update the min count to *3*.

   ```sh
  az aks create --resource-group akschallenge \
    --name <unique-aks-cluster-name> \
    --location <region> \
    --enable-addons monitoring \
    --kubernetes-version $version \
    --generate-ssh-keys \
    --enable-vmss \
    --enable-cluster-autoscaler \
    --min-count 1 \
    --max-count 3
  ```

  > **Important**: If you are using Service Principal authentication, for example in a lab environment, you'll need to use an alternate command to create the cluster with your existing Service Principal passing in the `Application Id` and the `Application Secret Key`.
  > ```sh
  > az aks create --resource-group akschallenge \
  >   --name <unique-aks-cluster-name> \
  >   --location <region> \
  >   --enable-addons monitoring \
  >   --kubernetes-version $version \
  >   --generate-ssh-keys \
  >   --enable-vmss \
  >   --enable-cluster-autoscaler
  >   --min-count 1 \
  >   --max-count 3 \
  >   --service-principal <application ID> \
  >   --client-secret "<application secret key>"
  > ```

  {% endcollapsible %}

#### Ensure you can connect to the cluster using `kubectl`

{% collapsible %}

> **Note** `kubectl`, the Kubernetes CLI, is already installed on the Azure Cloud Shell.

Authenticate

```sh
az aks get-credentials --resource-group akschallenge --name <unique-aks-cluster-name>
```

List the available nodes

```sh
kubectl get nodes
```

{% endcollapsible %}

> **Resources**
> * <https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough>
> * <https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az-aks-create>
> * <https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough-portal>