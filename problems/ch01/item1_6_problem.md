# 第1章 1.6 (Expert): Structを活用する

## 問題：株式取引履歴のメモリ最適化 (TradeHistory)

あなたは証券会社の取引システムを開発しています。
過去の取引履歴（Trade）をオンメモリで分析するツールを作っていますが、データ量が膨大（100万件以上）になり、メモリ不足（OOM）が発生しそうです。

### 要件
1.  **省メモリ化**: `Trade` オブジェクトのメモリ消費量を極限まで減らしてください。
2.  **不変性**: 取引履歴は確定した事実なので、作成後に変更されてはいけません。
3.  **利便性**: キーワード引数で初期化できるようにし、読みやすくしてください。

### 現在の実装 (遅くて重い)
```ruby
class Trade
  attr_reader :ticker, :price, :volume, :timestamp

  def initialize(ticker:, price:, volume:, timestamp:)
    @ticker = ticker
    @price = price
    @volume = volume
    @timestamp = timestamp
  end
end
```

### 課題
`lib/ch01/item1_6.rb` を修正し、`Struct` (または `Data`) を使ってメモリ効率の良い `Trade` クラスを実装してください。
ただし、単に `Struct.new` するだけでなく、以下の点に注意してください。
- キーワード引数 (`keyword_init: true`) をサポートすること。
- 継承を使わないパターン (`Trade = Struct.new(...)`) を検討すること。

### テスト
`bundle exec rspec spec/ch01/item1_6_spec.rb`
このテストでは `obj_space` を使って実際にメモリサイズを計測します。
