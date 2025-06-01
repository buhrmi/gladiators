require "bitcoin"

class Networks::Bitcoin
  Rails.logger = Logger.new(STDOUT)
  RPC_URL = ENV["BTC_RPC_URL"]

  def self.scan!
    current_block = self.get_blockcount
    @last_block ||= current_block - 1
    return unless current_block > @last_block
    Rails.logger.info("Scanning Bitcoin network for new blocks...")

    (@last_block + 1..current_block).each do |block_number|
      scan_block(block_number)
    end
    @last_block = current_block
  end

  def self.scan_block(block_number)
    Rails.logger.info("Scanning block number #{block_number}...")
    block_hash = self.call_rpc("getblockhash", [ block_number ])
    block = self.call_rpc("getblock", [ block_hash, 2 ])
    transactions = block["tx"]

    transactions.each do |tx|
      Rails.logger.info("Processing transaction: #{tx["txid"]}")
      scan_transaction(tx)
    end
  rescue StandardError => e
    Rails.logger.error("Error processing block #{block_number}: #{e.message} #{e.backtrace.join("\n")}")
  end


  def self.scan_transaction(tx)
    tx["vout"].each_with_index do |output, index|
      # we currently only support P2PKH
      next unless address = output["scriptPubKey"]["address"]
      next unless output["value"] > 0
      next unless wallet = Wallet.find_by(address: address, type: "Wallets::Bitcoin")

      if Deposit.where(txid: tx["txid"]).first
        Rails.logger.info("Transaction already exists: #{tx["txid"]}")
        next
      end

      Rails.logger.info("Depositing #{output['value']} BTC to wallet #{wallet.address} from transaction #{tx['txid']}")

      wallet.deposits.create!(
        symbol: "btc",
        user_id: wallet.user_id,
        amount: output["value"],
        confirmations: 0,
        confirmed: false,
        gateway: "bitcoin",
        txid: tx["txid"],
        fee: 0,
        vout_index: index,
        script_pubkey: output["scriptPubKey"]["hex"]
      )
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Error creating transaction record: #{e.message}")
    rescue StandardError => e
      Rails.logger.error("Error processing transaction #{tx['txid']}: #{e.message}")
    end
  end

  def self.call_rpc(method, params)
    response = HTTParty.post(RPC_URL, body: {
      method: method,
      params: params,
      id: 1,
      jsonrpc: "2.0"
    }.to_json, headers: { "Content-Type" => "application/json" })
    response.parsed_response["result"]
  rescue HTTParty::Error => e
    Rails.logger.error("HTTParty error: #{e.message}")
  end

  def self.get_blockcount
    self.call_rpc("getblockcount", [])
  end
end
