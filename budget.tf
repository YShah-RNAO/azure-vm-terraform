resource "azurerm_consumption_budget_resource_group" "devops_budget" {
  name              = "devops-budget"
  resource_group_id = azurerm_resource_group.rg.id

  amount     = 50
  time_grain = "Monthly"

  time_period {
    start_date = "2026-01-01T00:00:00Z"
  }

  notification {
    enabled        = true
    threshold      = 50
    operator       = "GreaterThan"
    contact_emails = ["your-team@company.com"]
  }

  notification {
    enabled        = true
    threshold      = 80
    operator       = "GreaterThan"
    contact_emails = ["your-team@company.com"]
  }

  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThan"
    contact_emails = ["your-team@company.com"]
  }
}

