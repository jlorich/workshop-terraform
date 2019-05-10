terraform {
  backend "azurerm" {
    container_name = "tfstate"
    key            = "terraform-workshop.tfstate"
  }
}

variable "environment" {
  type        = "string"
  description = "The desired deployment environment name"
  default     = "dev"
}

resource "azurerm_resource_group" "default" {
  name     = "terraform-pipelines-workshop-${var.environment}-rg"
  location = "West US"
}

resource "azurerm_app_service_plan" "default" {
  name                = "terraform-pipelines-workshop-plan"
  location            = "${azurerm_resource_group.default.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "default" {
  name                = "terraform-pipelines-workshop-myname-${var.environment}-app"
  location            = "${azurerm_resource_group.default.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  app_service_plan_id = "${azurerm_app_service_plan.default.id}"

  site_config = {
    always_on        = true
    linux_fx_version = "DOCKER|nginxdemos/hello"
  }
}
