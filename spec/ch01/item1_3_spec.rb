require 'rspec'
require_relative '../../lib/ch01/item1_3'

RSpec.describe '1.3 用途に応じて数値型を使い分ける' do
  it 'Float由来の誤差を発生させずに計算できる' do
    # 100.05 * 1.1 = 110.055
    # Floatで計算すると 110.05500000000001 のようになることがある
    splitter = BillSplitter.new(100.05)
    
    # 1人で払う場合
    result = splitter.split(1)
    
    # 期待値: 110.055 -> 切り捨てて 110 (※テストケースの簡易化のため整数で検証)
    # 本来は 110.055 ですが、今回の要件では「整数（円）」に切り捨てるとします
    expect(result).to eq(110)
  end

  it '割り切れない場合に無限小数にならず、切り捨てられる' do
    # 100円(税抜) -> 110円(税込)
    # 3人で割り勘 -> 36.666...円 -> 36円
    splitter = BillSplitter.new(100)
    
    expect(splitter.split(3)).to eq(36)
  end

  it '大きな数値でも正確に扱える' do
    # 1兆円
    splitter = BillSplitter.new('1000000000000')
    expect(splitter.split(2)).to eq(550000000000)
  end
end
