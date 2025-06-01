class Current < ActiveSupport::CurrentAttributes
  attribute :user
  attribute :currency, default: {
    postfix: "BTC",
    prefix: "₿",
    decimals: 8
  }
end
