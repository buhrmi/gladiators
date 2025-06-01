require "open-uri"

class User < ApplicationRecord
  JSON_OPTIONS = {
    only: %i[id name display_name],
    methods: %i[],
    include: {
      profile_image: {}
    }
  }.freeze

  PRIVATE_JSON_OPTIONS = {
    only: JSON_OPTIONS[:only] + %i[email email_verified],
    methods: JSON_OPTIONS[:methods] + %i[sgid],
    include: JSON_OPTIONS[:include]
  }.freeze

  has_secure_password
  has_one_attached :profile_image

  has_secure_token :email_verification_token

  has_many :deposits
  has_many :orders
  has_many :wallets

  scope :verified, -> { where(email_verified: true) }

  validates :name,
    uniqueness: { case_sensitive: false },
    format: { with: /\A[a-zA-Z0-9_]+\z/, message: "can only contain letters, numbers, and underscores" },
    length: { minimum: 1, maximum: 20 },
    allow_nil: true
  validates :display_name, length: { maximum: 50 }
  validates :bio, length: { maximum: 160 }
  validates :email, presence: true, uniqueness: {
    case_sensitive: false,
    length: { maximum: 50 },
    conditions: -> { where(email_verified: true) }
  }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 7 }, allow_nil: true

  after_create_commit :send_email_verification
  after_update_commit :broadcast_changes
  after_create_commit :load_profile_image_from_gravatar

  has_many :posts, dependent: :destroy

  def sgid
    to_sgid_param expires_in: nil
  end

  def send_email_verification
    UserMailer.verification_email(self, email_verification_token).deliver_later
  end

  def send_password_reset
    UserMailer.with(user: self).password_reset.deliver_later
  end

  def broadcast_changes
    changes = self.saved_changes.transform_values(&:last)
    UserChannel[self].store("current_user").merge(changes)
  end

  def load_profile_image_from_gravatar
    return if profile_image.attached?
    if email.present?
      gravatar_id = Digest::MD5.hexdigest(email)
      url = "https://www.gravatar.com/avatar/#{gravatar_id}?s=200&d=mp"
      self.profile_image.attach(io: URI.open(url), filename: "profile_image.jpg")
    end
  end

  def available_balances
    balances.merge(funds_in_orders) { |_, v1, v2| v1 - v2 }.with_indifferent_access
  end

  # This method calculates the current balances for the user
  # based on all historical data.
  # Deposits - Withdrawals + Buy Trades - Sell Trades
  # TODO: This is slow. Cache this in the positions table.
  def balances
    Hash.new(0)
      .merge({ "btc" => 0 })
      .merge(total_deposits) { |key, v1, v2| v1 + v2 }
    # .merge(total_buys) { |key, v1, v2| v1 + v2 }
    # .merge(total_sells) { |key, v1, v2| v1 - v2 }
  end

  def total_deposits
    deposits.confirmed.group(:symbol).sum(:amount)
  end

  def total_buys
    Hash.new(0)
      .merge(buy_trades.group(:symbol).sum(:amount)) { |key, v1, v2| v1 + v2 }
      .merge(sell_trades.group(:currency).sum(:paid)) { |key, v1, v2| v1 + v2 }
  end

  def total_sells
    Hash.new(0)
      .merge(sell_trades.group(:symbol).sum(:amount)) { |key, v1, v2| v1 + v2 }
      .merge(buy_trades.group(:currency).sum(:paid)) { |key, v1, v2| v1 + v2 }
  end

  def funds_in_orders
    orders.funded.group(:sell_symbol).sum(:remaining_sell_amount).with_indifferent_access
  end
end
