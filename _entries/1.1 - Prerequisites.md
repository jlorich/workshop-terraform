---
sectionid: prereq
sectionclass: h2
title: Prerequisites
parent-id: intro
---



### Terraform

Terraform is tool for deploying and managing Infrastructure (and more) as Code.  You can download the Terraform executables at <https://www.terraform.io/downloads.html>.  This lab will be using Terraform 0.11.13.


### Azure CLI

The Azure CLI is a command line interface for Azure.  The Azure CLI is also the way in which Terraform gains access to your Azure subscription.  You can find the installation instructions for the Azure CLI at <https://docs.microsoft.com/en-us/cli/azure/install-azure-cli>

### Azure Cloud Shell

You can also use the Azure Cloud Shell for this lab accessible at <https://shell.azure.com>.  The Azure Cloud Shell has the Azure CLI pre-installed and configured to connect to your Azure subscription as well as `helm`, `kubectl`, and `helm`.

### Azure subscription

#### If you have an Azure subscription

{% collapsible %}

Please use your username and password to login to <https://portal.azure.com>.

Also please authenticate your Azure CLI by running the command below on your machine and following the instructions.

```sh
az login
```

{% endcollapsible %}

#### If you have been given an access to a subscription as part of a lab, or you already have a Service Principal you want to use

{% collapsible %}
If you have lab environment credentials similar to the below or you already have a Service Principal you will use with this workshop,

![Lab environment credentials](media/lab-env.png)

Please then perform an `az login` on your machine using the command below, passing in the `Application Id`, the `Application Secret Key` and the `Tenant Id`.

```sh
az login --service-principal --username APP_ID --password "APP_SECRET" --tenant TENANT_ID
```

{% endcollapsible %}