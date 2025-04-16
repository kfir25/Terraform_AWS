
module "sqs" {
  source = "./modules/sqs"

  name = local.sqs_name
  tags = local.sqs_tags

}
