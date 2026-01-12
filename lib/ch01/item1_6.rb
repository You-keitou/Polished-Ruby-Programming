# frozen_string_literal: true

# FIXME: クラス定義ではなく、Struct (または Data) を使って書き換えてください。
# メモリ効率が最優先です。

# class Trade
#   attr_reader :ticker, :price, :volume, :timestamp
# 
#   def initialize(ticker:, price:, volume:, timestamp:)
#     @ticker = ticker
#     @price = price
#     @volume = volume
#     @timestamp = timestamp
#   end
# end

Trade = Struct.new(:ticker, :price, :volume, :timestamp)
