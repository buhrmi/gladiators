class Wallets::Bitcoin < Wallet
  ROOT = MoneyTree::Node.from_bip32(ENV["BTC_XPUB"])

  def initialize(*)
    super
    self.address = generate_address
  end

  def generate_address
    network = Rails.env.production? ? :bitcoin : :bitcoin_testnet
    ROOT.node_for_path(path).to_address network: network
  end

  def path
    "m/#{user_id}/#{index}"
  end
end
