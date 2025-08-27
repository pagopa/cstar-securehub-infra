resource "awscc_location_api_key" "this" {
  key_name    = "${local.product}-${var.domain}-api-key"
  description = "This API key is used for the idpay bonus elettrodomestici project"
  no_expiry   = false
  expire_time = formatdate("YYYY-MM-DD'T'HH:mm:ss'Z'", timeadd(timestamp(), "8760h")) # 1 year
  restrictions = {
    allow_actions = [
      "geo-maps:GetTile",
      "geo-maps:GetStaticMap",
      "geo-places:Autocomplete",
      "geo-places:GetPlace",
      "geo-places:Geocode"
    ]
    allow_resources = [
      "arn:aws:geo-maps:${var.aws_region}::provider/default",
      "arn:aws:geo-places:${var.aws_region}::provider/default"
    ]
    allow_referers = local.allow_referers_service_locator
  }

  tags = [for key, value in local.tags : {
    key   = key
    value = value
  }]
}
