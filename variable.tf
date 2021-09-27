variable "dev_cluster" {
  type = object({
    location = string
    prefix   = string
  })
}
