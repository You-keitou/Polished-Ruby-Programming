#!/usr/bin/env ruby
# frozen_string_literal: true

class StructQuiz
  def initialize
    @score = 0
    @questions = [
      {
        title: "ケース1: Struct の継承パターン",
        code: "class User < Struct.new(:id, :name); end",
        question: "この定義方法は『Polished Ruby Programming』において、なぜ避けるべきとされている？",
        choice_a: "実行速度が極端に遅くなるから",
        choice_b: "無名クラスが継承階層に入り、予期しない動作や継承の複雑さを生むから",
        choice_c: "Ruby 3.0以降で非推奨になったから",
        answer: "B",
        explanation: "正解は B です。

`class User < Struct.new(...)` と書くと、`User` と `Struct` の間に「名前のない中間クラス」が挟まってしまいます。
著者は `User = Struct.new(...)` と定義するか、あるいは Struct.new にブロックを渡してメソッドを定義することを推奨しています。"
      },
      {
        title: "ケース2: メモリ効率 (Memory footprint)",
        requirement: "100万個の「座標データ (x, y)」をメモリに保持したい。",
        question: "「通常のクラス」「Hash」「Struct」の中で、一般的に最もメモリ消費が少ないのは？",
        choice_a: "Hash",
        choice_b: "通常のクラス (attr_accessor 使用)",
        choice_c: "Struct",
        answer: "C",
        explanation: "正解は C です。

`Struct` はインスタンス変数をハッシュ形式で保持せず、内部的に最適化されたスロットに格納するため、通常のクラスやHashよりもメモリ効率が良い傾向にあります。
大量の小さなオブジェクトを作る場合は、Struct が非常に有利です。"
      },
      {
        title: "ケース3: Ruby 3.2 の新機能 'Data'",
        requirement: "値が変更されないことを保証したい「不変なデータ構造 (Value Object)」を定義したい。",
        question: "Struct に代わる Ruby 3.2 以降の推奨クラスは？",
        choice_a: "ImmutableStruct",
        choice_b: "Data",
        choice_c: "Record",
        answer: "B",
        explanation: "正解は B です。

`Data.define(:id, :name)` は `Struct` に似ていますが、生成されたオブジェクトは不変 (Immutable) です。
`Struct` のようにあとから値を書き換えることができないため、バグを防ぎやすく、現代的な設計に適しています。"
      },
      {
        title: "ケース4: キーワード引数への対応",
        code: "Point = Struct.new(:x, :y, keyword_init: true)\np = Point.new(x: 10, y: 20)",
        question: "この `keyword_init: true` を使う最大のメリットは？",
        choice_a: "引数の順番を覚えなくて済むため、可読性と安全性が向上する",
        choice_b: "内部的な処理が Hash になるため高速化する",
        choice_c: "JSONへの変換が自動化される",
        answer: "A",
        explanation: "正解は A です。

属性が多いデータ構造では、位置引数 (`10, 20, 30...`) だと順番を間違えるリスクがあります。
`keyword_init: true` を使うことで、シニアエンジニアが好む「自己記述的で安全なコード」になります。"
      }
    ]
  end

  def run
    puts "\n=== 第1章 1.6 クイズ: The Power of Struct & Data ===\n"
    @questions.each_with_index do |q, i|
      puts "---------------------------------------------------"
      puts "Q#{i + 1}. #{q[:title]}"
      puts "---------------------------------------------------"
      puts "【コード/背景】\n#{q[:code]}" if q[:code]
      puts "【問い】\n#{q[:question]}"
      
      puts "[A] #{q[:choice_a]}"
      puts "[B] #{q[:choice_b]}"
      puts "[C] #{q[:choice_c]}"

      print "\nあなたの選択 > "
      input = gets.chomp.upcase
      
      if input == q[:answer]
        puts "\n✅ 正解！"
        @score += 1
      else
        puts "\n❌ 残念..."
      end
      
      puts "\n【解説】"
      puts q[:explanation]
      puts "\n(Enterで次へ)"
      gets
    end
    puts "終了！ スコア: #{@score} / #{@questions.size}"
  end
end

StructQuiz.new.run
