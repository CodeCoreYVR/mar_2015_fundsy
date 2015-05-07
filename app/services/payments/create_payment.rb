class Payments::CreatePayment

  include Virtus.model

  attribute :stripe_token, String
  attribute :user, User
  attribute :pledge, Pledge
  attribute :pay_with_existing, Boolean

  def call
    ActiveRecord::Base.transaction do
      begin
        update_user_info unless pay_with_existing
        charge && update_pledge
      rescue => e
        Rails.logger.info "Exception happened #{e.message}"
        raise ActiveRecord::Rollback.new
      end
    end
  end

  private

  def customer
    @customer ||= Stripe::Customer.create(
                      description: "Customer for #{user.email}",
                      source: stripe_token
                    )
  end

  def update_user_info
    user.stripe_customer_token = customer.id
    user.stripe_last4         = customer.sources.data[0].last4
    user.stripe_card_type     = customer.sources.data[0].brand
    user.save
  end

  def charge
    charge = Stripe::Charge.create(
      amount: pledge.amount * 100,
      currency: "cad",
      customer: user.stripe_customer_token, 
      description: "Pledge for #{@pledge.campaign.title}"
    )
  end

  def update_pledge
    pledge.stripe_txn_id = charge.id
    pledge.pay
    pledge.save
  end


end
