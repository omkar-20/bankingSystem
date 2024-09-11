class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :account, null: false, foreign_key: true
      t.string :transaction_type, null: false
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.string :status, default: 'completed'

      t.timestamps
    end
  end
end
