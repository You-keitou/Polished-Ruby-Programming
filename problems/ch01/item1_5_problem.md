# 第1章 1.5: 配列、ハッシュ、セット（集合）を使い分ける

## 問題：遅すぎるログフィルター (LogAnalyzer)

数万人の監視対象ユーザーのログを抽出する処理が、データ量の増加とともに劇的に遅くなっています。
計算量のオーダー（Big O）を意識して、パフォーマンス・チューニングを行ってください。

### 現状のコード (O(N^2) の罠)
```ruby
def filter_logs(logs, target_user_ids)
  # target_user_ids は配列 (サイズ: M)
  # logs は配列 (サイズ: N)
  # include? は O(M) なので、全体で O(N * M)
  logs.select do |log|
    target_user_ids.include?(log[:user_id])
  end
end
```

### 課題
`lib/ch01/item1_5.rb` を修正し、以下の要件を満たしてください。

1.  **計算量の改善**: `Array#include?` の繰り返しを排除し、`Set` または `Hash` を使って O(1) の検索を実現する。
2.  **不変性の保証**: 検索用のセット（辞書）に格納するキーは、途中で変更されないように freeze などの対策を講じること（文字列の場合）。

### テスト
今回、パフォーマンステストが含まれています。改善前はタイムアウト（または非常に時間がかかる）しますが、改善後は一瞬で終わるはずです。

`bundle exec rspec spec/ch01/item1_5_spec.rb`
