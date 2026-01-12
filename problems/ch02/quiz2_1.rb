#!/usr/bin/env ruby
# frozen_string_literal: true

class DelegationQuiz
  def initialize
    @score = 0
    @questions = [
      {
        title: "ケース1: Arrayの継承",
        requirement: "独自のメソッド `average` を持つ `ScoreList` クラスを作りたい。",
        code: "class ScoreList < Array\n  def average\n    sum / size.to_f\n  end\nend",
        question: "この継承アプローチの最大の問題点は？",
        choice_a: "RubyのArrayはC言語で実装されているため、継承すると遅くなる",
        choice_b: "`pop`, `shift`, `clear` などの破壊的メソッドも公開されてしまい、データの整合性を守れなくなる",
        choice_c: "`average` メソッドの名前が `Enumerable` モジュールと衝突する",
        answer: "B",
        explanation: "正解は B です。\n\n`Array` を継承すると、配列が持つ100以上のメソッドが全て公開インターフェースになってしまいます。\nカプセル化が壊れ、意図しない操作（要素の削除や挿入）を許してしまいます。\n必要な機能だけを公開する「委譲」を使うべきです。"
      },
      {
        title: "ケース2: Hashの継承 vs 委譲",
        requirement: "HTTPヘッダーを扱う `Headers` クラスを作りたい。キーは大文字小文字を区別しないようにしたい。",
        question: "ActiveSupport (Rails) の `HashWithIndifferentAccess` はどう実装されている？",
        choice_a: "`Hash` を継承している",
        choice_b: "`Hash` を継承せず、内部にハッシュを持ち、必要なメソッドだけを委譲・実装している",
        choice_c: "`BasicObject` を継承している",
        answer: "A",
        explanation: "正解は A です...が、これは**悪い例（または歴史的経緯）**としてよく挙げられます。\n\n実は `HashWithIndifferentAccess` は `Hash` を継承していますが、そのせいで `Hash` の持つ大量のメソッドとの互換性を保つために苦労しています。\n現代的な設計（例えば `Rack::Headers` など）では、継承を使わずに委譲ベースで作られることが多いです。"
      },
      {
        title: "ケース3: Forwardable モジュール",
        code: "class Queue\n  extend Forwardable\n  def_delegators :@array, :push, :shift\n  def initialize; @array = []; end\nend",
        question: "このコードのメリットは？",
        choice_a: "パフォーマンスが継承より速い",
        choice_b: "`push` と `shift` 以外のメソッド（`delete_at`など）を隠蔽でき、Queueとしての振る舞いを強制できる",
        choice_c: "Ruby 3.0以降でしか動かないモダンな書き方である",
        answer: "B",
        explanation: "正解は B です。\n\n`Forwardable` を使うと、公開したいメソッドだけを明示的に指定できます。\nこれにより、クラスのインターフェースを小さく保ち、意図しない使いかたを防ぐことができます（Least Surprise）。"
      }
    ]
  end

  def run
    puts "\n=== 第2章 2.1 クイズ: Inheritance vs Delegation ===\n"
    @questions.each_with_index do |q, i|
      puts "---------------------------------------------------"
      puts "Q#{i + 1}. #{q[:title]}"
      puts "---------------------------------------------------"
      puts "【要件/コード】\n#{q[:requirement]}"
      puts "#{q[:code]}" if q[:code]
      puts "\n【問い】\n#{q[:question]}"
      
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

DelegationQuiz.new.run
