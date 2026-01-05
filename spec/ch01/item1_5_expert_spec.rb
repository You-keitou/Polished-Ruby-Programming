require 'rspec'
require_relative '../../lib/ch01/item1_5_expert'

RSpec.describe '1.5 (Expert) IdentitySet' do
  it 'IDが同じなら同一とみなすが、add時は新しいもので上書きする' do
    set = IdentitySet.new
    
    item_v1 = Item.new(1, 1, 'Sword')
    item_v2 = Item.new(1, 2, 'Sword +1') # IDは同じだがバージョンが違う

    # 1. 最初に追加
    set.add(item_v1)
    expect(set.size).to eq(1)
    expect(set.to_a.first.version).to eq(1)

    # 2. include? は IDだけで判定されるべき
    # （バージョン違いのインスタンスを渡しても true になること）
    expect(set.include?(item_v2)).to be true

    # 3. add すると上書きされるべき (標準のSetとは逆の挙動)
    set.add(item_v2)
    expect(set.size).to eq(1) # サイズは増えない
    expect(set.to_a.first.version).to eq(2) # 中身は入れ替わっている
    expect(set.to_a.first.name).to eq('Sword +1')
  end

  it 'Itemのeql?実装が安全であること（ハッシュ衝突対策）' do
    # 意図的にハッシュ衝突を起こすモック
    item1 = Item.new(100, 1, 'A')
    item2 = Item.new(200, 1, 'B')
    
    # 強制的にハッシュ値を同じにする（Rubyの内部挙動をハック）
    allow(item1).to receive(:hash).and_return(9999)
    allow(item2).to receive(:hash).and_return(9999)

    # ハッシュ値が同じでも、IDが違うなら eql? は false を返すべき
    expect(item1.eql?(item2)).to be false
  end
end
