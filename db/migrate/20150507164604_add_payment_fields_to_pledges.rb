class AddPaymentFieldsToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :aasm_state, :string
    add_column :pledges, :stripe_txn_id, :string
  end
end
