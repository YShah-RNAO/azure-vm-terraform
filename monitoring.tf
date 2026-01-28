# Create Log Analytics Workspace

resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-devops-demo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Create Availability Alert (HTTP check)

resource "azurerm_monitor_scheduled_query_rules_alert" "website_down" {
  name                = "website-down-alert"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  data_source_id = azurerm_log_analytics_workspace.law.id
  severity       = 1
  enabled        = true
  frequency      = 5
  time_window    = 5

  query = <<KQL
AppRequests
| where Url contains "https://${azurerm_public_ip.pip.ip_address}"
| summarize count() by bin(TimeGenerated, 5m)
| where count_ == 0
KQL

  trigger {
    operator  = "GreaterThan"
    threshold = 0
  }

  action {
    action_group= [ 
      azurerm_monitor_action_group.alerts.id
    ]
  }
}

# Application Insights

resource "azurerm_application_insights" "appi" {
  name                = "appi-devops-demo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.law.id
}

# Monitor Nginx website

#resource "azurerm_application_insights_web_test" "web_test" {
#  name                    = "website-uptime-test"
#  location                = "canadacentral"
#  resource_group_name     = azurerm_resource_group.rg.name
#  application_insights_id = azurerm_application_insights.appi.id
#  kind                    = "ping"
#  frequency               = 300
#  timeout                 = 30
#  enabled                 = true

#  geo_locations = ["canadacentral"]

#  configuration = <<XML
#<WebTest Name="Website Uptime Test" Enabled="True" Timeout="30" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010">
#  <Items>
#    <Request
#      Method="GET"
#      Url="https://${azurerm_public_ip.pip.ip_address}"
#      ThinkTime="0"
#      Timeout="30"
#      ParseDependentRequests="True"
#      FollowRedirects="True" />
#  </Items>
#</WebTest>
#XML

#}

# Action Group (Email Alerts)

resource "azurerm_monitor_action_group" "alerts" {
  name                = "devops-alerts"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "alerts"

  email_receiver {
    name          = "admin"
    email_address = var.alert_email
  }
}

# Website Down Alert

resource "azurerm_monitor_metric_alert" "website_down" {
  name                = "website-down"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_application_insights.appi.id]
  description         = "Website is down"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = "availabilityResults/availabilityPercentage"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 99
  }

  action {
    action_group_id = azurerm_monitor_action_group.alerts.id
  }
}

# High CPU Alert

resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = "vm-high-cpu"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_linux_virtual_machine.vm.id]
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.alerts.id
  }
}

# VM Disk / CPU Alert

resource "azurerm_monitor_metric_alert" "vm_cpu" {
  name                = "vm-high-cpu"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_linux_virtual_machine.vm.id]
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.alerts.id
  }
}
