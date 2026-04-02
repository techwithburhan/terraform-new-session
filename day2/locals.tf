# ─── LOCAL VALUES ────────────────────────────────────────────────────
# Locals are computed values reused across configs — DRY principle
locals {
  name_prefix    = "day2-${var.environment}"
  selected_type  = var.instance_type[var.environment]

  common_tags = {
    Environment = var.environment
    Owner       = "infra-team"
    CostCenter  = "engineering"
  }
}
