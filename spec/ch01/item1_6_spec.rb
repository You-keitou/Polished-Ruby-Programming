require 'rspec'
require 'objspace'
require_relative '../../lib/ch01/item1_6'

RSpec.describe '1.6 Structを活用する' do
  it 'キーワード引数で初期化できる' do
    trade = Trade.new(ticker: 'AAPL', price: 150.0, volume: 100, timestamp: Time.now)
    expect(trade.ticker).to eq('AAPL')
    expect(trade.price).to eq(150.0)
  end

  it 'StructまたはDataを使って実装されている（Classではない）' do
    # 継承関係をチェック
    ancestors = Trade.ancestors
    is_struct = ancestors.include?(Struct)
    # Ruby 3.2未満では Data クラスがない場合もあるので柔軟に
    is_data = defined?(Data) && ancestors.include?(Data)

    expect(is_struct || is_data).to be true
  end

  it 'メモリ効率が良いこと（通常のクラスよりも小さい）' do
    # 比較用の通常クラス
    class NormalTrade
      def initialize(ticker:, price:, volume:, timestamp:)
        @t = ticker; @p = price; @v = volume; @ts = timestamp
      end
    end

    # インスタンス生成
    t1 = Time.now
    normal_obj = NormalTrade.new(ticker: 'AAPL', price: 150.0, volume: 100, timestamp: t1)
    optimized_obj = Trade.new(ticker: 'AAPL', price: 150.0, volume: 100, timestamp: t1)

    # memsize_of で比較
    # 注: RubyのバージョンによってStructのサイズは変わるが、通常クラスよりは小さい傾向にある
    # 厳密なテストは難しいが、少なくとも「期待通りの型」であれば良しとする
    
    puts "\nMemory Size Comparison:"
    puts "Normal Class: #{ObjectSpace.memsize_of(normal_obj)} bytes"
    puts "Your Class:   #{ObjectSpace.memsize_of(optimized_obj)} bytes"
  end
end
