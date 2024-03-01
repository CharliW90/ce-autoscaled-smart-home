public_subnets = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.8.0/24", "10.0.9.0/24", "10.0.10.0/24"]
availability_zones = ["eu-west-2a","eu-west-2b","eu-west-2c"]

apps = [
  {app_name = "smart_auth", image = "ami-08609926b385c1b30", public = false},
  {app_name = "smart_heating", image = "ami-0475298a7af0c9400", public = true},
  {app_name = "smart_lighting", image = "ami-0422486d3b2fb792c", public = true},
  {app_name = "smart_status", image = "ami-01046e2757fc99f6a", public = true}
]

key_name = "init-machine-key"