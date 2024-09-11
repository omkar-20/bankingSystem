class Transaction < ApplicationRecord
  belongs_to :account

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true, inclusion: { in: %w[deposit withdrawal] }
  validates :status, presence: true
  validate :sufficient_balance_for_withdrawal, if: -> { transaction_type == 'withdrawal' }

  after_create :update_account_balance

  def update_account_balance
    if transaction_type == 'deposit'
      account.update(balance: account.balance + amount)
    elsif transaction_type == 'withdrawal'
      account.update(balance: account.balance - amount)
    end
  end

  def sufficient_balance_for_withdrawal
    if account.present? && amount > account.balance
      errors.add(:amount, 'is greater than available balance for withdrawal')
    end
  end
end
