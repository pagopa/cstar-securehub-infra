resource "awscc_location_api_key" "api_key" {
  key_name    = "${local.product}-${var.domain}-v2-api-key"
  description = "This API key is used for the idpay bonus elettrodomestici project"
  no_expiry   = true
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
