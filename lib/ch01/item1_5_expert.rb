class Item
  attr_reader :id, :version, :name

  def initialize(id, version, name)
    @id = id
    @version = version
    @name = name
  end

  # FIXME: IDベースの同一性を正しく定義してください。
  # ハッシュ値の衝突を考慮し、eql? は厳密な比較を行うこと。
  def hash
    "#{@id} #{@version} #{@name}".hash
  end

  def eql?(other)
    @id == other.id && @version == other.version && @name == other.name
  end
end

class IdentitySet
  # ヒント: 内部で Hash を使うと楽です。
  # Key: Item (または Item.id?)
  # Value: Item

  def initialize
    @store = {}
  end

  # アイテムを追加。IDが同じなら上書きする (Last Write Wins)
  def add(item)
    @store[item.id] = item
  end

  # IDが同じアイテムが含まれているか？
  def include?(item)
    @store.key?(item.id)
  end

  # セット内のアイテム数を返す
  def size
    @store.size
  end
  
  # 全要素を配列で返す
  def to_a
    @store.values
  end
end
