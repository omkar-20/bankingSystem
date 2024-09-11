class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one :account, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be a valid email addres' }
  before_validation :validate_mobile_number, if: :updating?
  before_validation :validate_names, if: :updating_names?

  enum role: { admin: 'admin', customer: 'customer' }

  scope :customer, -> { where(role: 'customer') }

  scope :active, -> { where(is_active: true) }

  def self.create_customer_with_account(params)
    plain_password = params[:password]
    customer = User.new(params.merge(role: 'customer'))

    if customer.save
      account = customer.create_account(balance: 0.0, status: 'active', account_number: generate_account_number)

      if account.persisted?
        CustomerMailer.account_creation_email(customer, plain_password, account).deliver_now
        return customer, account, nil
      else
        customer.destroy
        return nil, nil, account.errors.full_messages
      end
    else
      return nil, nil, customer.errors.full_messages
    end
  end

  private

  def self.generate_account_number
    SecureRandom.random_number(10**10).to_s.rjust(10,'0')
  end

  def validate_mobile_number
    if mobile_number.present?
      errors.add(:mobile_number, 'must be 10 digits long and start with 7, 8, or 9') unless valid_mobile_number?
    end
  end

  def valid_mobile_number?
    mobile_number.match?(/\A[789]\d{9}\z/)
  end

  def validate_names
    errors.add(:first_name, "can't be blank") if first_name.blank?
    errors.add(:last_name, "can't be blank") if last_name.blank?

    unless first_name.match?(/\A[a-zA-Z]+\z/)
      errors.add(:first_name, 'can only contains letters')
    end

    unless last_name.match?(/\A[a-zA-Z]+\z/)
      errors.add(:last_name, 'can only contains letters')
    end
  end

  def updating?
    persisted?
  end

  def updating_names?
    updating? && (first_name.present? || last_name.present?)
  end
end
