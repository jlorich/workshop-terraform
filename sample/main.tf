variable "environment" {
  type        = "string"
  description = "The desired deployment enviornment name"
  default     = "dev"
}

resource "azurerm_resource_group" "default" {
  name     = "terraform-pipelines-workshop-${var.enviornment}-rg"
  location = "West US"
}

resource "azurerm_app_service_plan" "default" {
  name                = "terraform-pippelines-workshop-plan"
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
  name                = "terraform-pipelines-workshop-myname-${var.enviornment}-app"
  location            = "${azurerm_resource_group.default.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  app_service_plan_id = "${azurerm_app_service_plan.default.id}"

  site_config = {
    always_on        = true
    linux_fx_version = "DOCKER|hello-world"
  }
}
