#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require 'benchmark'

class CollectionQuiz
  def initialize
    @score = 0
    @questions = [
      {
        title: "ケース1: 巨大リストの包含チェック (N+1問題の亜種)",
        requirement: "10万人の `blocked_users` リストがあり、全ユーザー(100万人)に対して「ブロックされているか」を判定してフィルタリングしたい。",
        code: "blocked_users = [...]
users.select { |u| blocked_users.include?(u.id) }",
        question: "`blocked_users` が Array の場合と Set の場合で、計算量オーダーはどう変わるか？",
        choice_a: "Array: O(N), Set: O(1) -> 全体で Array: O(M*N), Set: O(M)",
        choice_b: "どちらも O(N) なので変わらない",
        choice_c: "RubyのArrayは最適化されているので、Arrayの方が速い",
        answer: "A",
        explanation: "正解は A です。\n\nArray#include? は線形探索なので O(N) です。これをループ内で行うと O(M*N) になり、データ量が増えると指数関数的に遅くなります。\nSet#include? (または Hashのキー検索) はハッシュ探索なので O(1) です。\n数万件を超えるリストとの照合を行う場合は、必ず Set か Hash に変換すべきです。"
      },
      {
        title: "ケース2: 共通部分の抽出 (Intersection)",
        requirement: "2つの巨大なIDリスト (A: 10万件, B: 10万件) があり、両方に存在するIDだけを抽出したい。",
        code: "common_ids = list_a & list_b",
        question: "Rubyの `Array#&` (積集合) の実装はどうなっている？",
        choice_a: "単純な二重ループ (O(N^2))",
        choice_b: "内部的に一時的なハッシュテーブルを作成して高速化している (O(N+M))",
        choice_c: "ソートしてから二分探索している (O(N log N))",
        answer: "B",
        explanation: "正解は B です。\n\nRubyの `Array#&` は非常に賢く実装されており、内部的にハッシュテーブルを作成して重複排除と共通項抽出を行います。\nそのため、わざわざ手動で `Set.new(list_a) & Set.new(list_b)` と書かなくても、`Array#&` そのもので十分高速です。\nただし、何度も同じリストに対して演算を行うなら、最初から Set に変換しておく方が「変換コスト」を節約できます。"
      },
      {
        title: "ケース3: 重複の排除 (Uniqueness)",
        requirement: "APIレスポンスから重複したIDを取り除きたい。順序は保持したい。",
        code: "ids.uniq",
        question: "`uniq` メソッドのメモリ挙動として正しいのは？",
        choice_a: "配列をインプレースで書き換えるためメモリ効率が良い",
        choice_b: "内部的にハッシュを作るため、一時的にメモリ消費が増える",
        choice_c: "隣り合う要素だけ比較するためメモリ消費は少ないが、ソート済みでないと機能しない",
        answer: "B",
        explanation: "正解は B です。\n\n`uniq` も内部でハッシュテーブル（Set的な構造）を使って既出チェックを行います。\nそのため、非常に巨大な配列で `uniq` を呼ぶと、一時的に大きなメモリを消費する可能性があります。\nUNIXコマンドの `uniq` と違い、ソート済みである必要はありません。"
      },
      {
        title: "ケース4: Setの落とし穴 (Mutable Objects)",
        requirement: "Setに可変オブジェクト（例えば変更可能なString）を入れた後、そのオブジェクトの内容を変更した。",
        code: "s = Set.new\nstr = \"hello\"\ns.add(str)\nstr.upcase! # 内容を変更",
        question: "この後の `s.include?(\"HELLO\")` と `s.include?(\"hello\")` の挙動は？",
        choice_a: "Setが自動追従して \"HELLO\" でヒットする",
        choice_b: "ハッシュ値が壊れて、どちらでも検索できなくなる（行方不明になる）",
        choice_c: "元のハッシュ値のままなので \"hello\" でヒットする",
        answer: "B",
        explanation: "正解は B です（最悪のケース）。\n\nSet（およびHashのキー）は、オブジェクトの `hash` 値をインデックスとして使用します。\n格納後にオブジェクトの内容が変わり、`hash` メソッドの返り値が変わってしまうと、Set内部のバケット位置と実際のハッシュ値が不一致になります（Rehashが必要）。\nSetやHashのキーには、必ず **Frozen Object (不変オブジェクト)** を使うのが鉄則です。"
      }
    ]
  end

  def run
    puts "\n=== 第1章 1.5 クイズ: Expert Collections ===\n"
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

CollectionQuiz.new.run
