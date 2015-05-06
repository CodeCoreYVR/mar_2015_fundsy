json.title @campaign.upcased_title
json.description @campaign.truncated_description
json.goal @campaign.goal
json.ends_on @campaign.ends_on

json.reward_levels @campaign.reward_levels do |rl|
  json.amount rl.amount
  json.description rl.description
end
