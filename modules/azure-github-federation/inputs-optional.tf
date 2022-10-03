variable "env" {
  description = "Environment value."
  type        = string
  default     = null
}
variable "product" {
  description = "https://hmcts.github.io/glossary/#product"
  type        = string
  default     = null
}
variable "builtFrom" {
  description = "Name of the GitHub repository this application is being built from."
  type        = string
  default     = null
}
