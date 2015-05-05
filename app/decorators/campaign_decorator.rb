class CampaignDecorator < Draper::Decorator
  delegate_all

  def upcased_title
    object.title.upcase
  end

  def goal
    h.number_to_currency(object.goal)
  end

  def ends_on
    object.ends_on.strftime("%Y-%b-%d")
  end

  def edit_button
    if h.can? :edit, object
        h.link_to "Edit", h.edit_campaign_path(object), class: "btn btn-info"
    end
  end

  def delete_button
    if h.can? :destroy, object
      h.link_to "Delete", object, class: "btn btn-danger", 
                method: :delete, data: {confirm: "Are you sure?"}
    end
  end

  def publish_button
    if (h.can? :publish, object) && object.draft?
      h.link_to "Publish", h.campaign_publishings_path(object), 
                class: "btn btn-info", method: :post, 
                  data: {confirm: "Are you sure you want to publish this campaign?"}
    end
  end

  def truncated_description
    object.description.truncate(140)
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
