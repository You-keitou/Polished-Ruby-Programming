require 'rspec'
require 'benchmark'
require_relative '../../lib/ch01/item1_5_diff'

RSpec.describe '1.5 (応用) 集合演算による高速Diff' do
  let(:syncer) { Syncer.new }

  it '差分を正しく計算できる（機能要件）' do
    current = [1, 2, 3, 4]
    new_list = [3, 4, 5, 6]

    result = syncer.sync(current, new_list)
    
    expect(result[:create]).to contain_exactly(5, 6)
    expect(result[:delete]).to contain_exactly(1, 2)
    expect(result[:keep]).to contain_exactly(3, 4)
  end

  it '数十万件のデータでも高速に処理できる' do
    # 10万件ずつのデータ
    size = 100_000
    # current: 0...100,000
    current = (0...size).to_a
    # new:     50,000...150,000 (半分被る、半分新規)
    new_list = (size / 2 ... size + size / 2).to_a

    time = Benchmark.realtime do
      syncer.sync(current, new_list)
    end

    puts "\nDiff Execution Time: #{time.round(4)} sec"
    
    # 配列演算のままだと遅くなるが、Setなら一瞬
    # 0.3秒以内を目指す
    expect(time).to be < 0.3
  end
end
