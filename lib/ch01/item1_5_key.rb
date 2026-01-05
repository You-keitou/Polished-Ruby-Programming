class User
  attr_accessor :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

  # FIXME: Hashのキーとして id が同じなら同一人物とみなすように
  # 以下の2つのメソッドを実装してください。

  def hash
    # id に基づくハッシュ値を返す
    # ヒント: id.hash を使うと簡単
    @id.hash
  end

  def eql?(other)
    # id が一致するかどうかを返す
    hash == other.hash
  end
end
