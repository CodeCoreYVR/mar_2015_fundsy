json.array! @campaigns do |campaign|
  json.id campaign.id
  json.title campaign.title
  json.description campaign.description
  json.created_on campaign.created_at.strftime("%Y-%b-%d")
end
