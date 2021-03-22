terraform {
  backend "azurerm" {
    resource_group_name   = "rg-terraform-tstate"
    storage_account_name  = "satstate19285"
    container_name        = "terraform-state"
    key                   = "terraform.tfstate"
  }
}

# Configure the Azure provider
provider "azurerm" { 
  # The "feature" block is required for AzureRM provider 2.x. 
  # If you are using version 1.x, the "features" block is not allowed.
  features {}
}

terraform {
  required_providers {
    hiera5 = {
      source = "sbitio/hiera5"
      version = "0.2.7"
    }
  }
}

provider "hiera5" {
  # Optional
  config = "~/hiera.yaml"
  # Optional
  scope = {
    environment = "live"
    service     = "api"
    # Complex variables are supported using pdialect
    facts       = "{timezone=>'CET'}"
  }
  # Optional
  merge  = "deep"
}

data "hiera5_hash" "aws_tags" {
  key = "aws_tags"
}

output "output" {
 value = data.hiera5_hash.aws_tags
}
