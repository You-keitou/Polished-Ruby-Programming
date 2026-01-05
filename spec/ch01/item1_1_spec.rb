require 'rspec'
require_relative '../../lib/ch01/item1_1'

RSpec.describe '1.1 いつ組み込みクラスを使うべきか' do
  let(:categorizer) { WordCategorizer.new }

  it '特定のカテゴリに単語を追加できる' do
    categorizer.add_word(:fruit, 'apple')
    expect(categorizer.list_category(:fruit)).to include('apple')
  end

  it '新しいカテゴリに単語が漏れない' do
    categorizer.add_word(:fruit, 'banana')
    
    # バグのある実装では、:vegetable は :fruit と同じ配列インスタンスを共有するため失敗します
    expect(categorizer.list_category(:vegetable)).to be_empty
  end

  it 'カテゴリごとに独立したリストを保持する' do
    categorizer.add_word(:colors, 'red')
    categorizer.add_word(:animals, 'cat')

    expect(categorizer.list_category(:colors)).to eq(['red'])
    expect(categorizer.list_category(:animals)).to eq(['cat'])
  end
end

