require 'rspec'
require_relative '../../lib/ch01/item1_5_key'

RSpec.describe '1.5 (応用2) Hashキーのカスタマイズ' do
  it '異なるインスタンスでもIDが同じならHashのキーとして同一視される' do
    user1 = User.new(1, 'Alice')
    user2 = User.new(1, 'Alice (Updated)') # IDは同じ
    user3 = User.new(2, 'Bob')

    cache = {}
    
    # user1 をキーにして値を保存
    cache[user1] = 'User 1 Data'

    # user2 (別インスタンス) で値を取り出せるべき
    expect(cache[user2]).to eq('User 1 Data')
    
    # 値を上書き
    cache[user2] = 'Updated Data'
    expect(cache[user1]).to eq('Updated Data')

    # 別のIDは別物
    expect(cache[user3]).to be_nil
  end

  it 'Setでも正しく重複排除される' do
    require 'set'
    set = Set.new
    
    set << User.new(100, 'A')
    set << User.new(100, 'B') # IDが同じなので追加されないはず
    set << User.new(200, 'C')

    expect(set.size).to eq(2)
  end
end
