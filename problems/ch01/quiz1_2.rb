#!/usr/bin/env ruby
# frozen_string_literal: true

class Quiz
  def initialize
    @score = 0
    @questions = [
      {
        title: "ケース1: 環境変数の落とし穴 (Rails/Env)",
        requirement: "環境変数 'ENABLE_FEATURE' を読み込んで、機能のオン/オフを判定したい。\n環境変数がセットされていない場合は、デフォルトで `true` (有効) にしたい。\n環境変数は文字列として返ってくることに注意。",
        code: "ENV['ENABLE_FEATURE'] || true",
        question: "ユーザーが `ENABLE_FEATURE='false'` と設定しました。このコードの評価結果はどうなる？",
        choice_a: "true (有効)",
        choice_b: "false (無効)",
        choice_c: "\"false\" (文字列)",
        answer: "C",
        explanation: "正解は C (\"false\") です。\n\nRubyでは `nil` と `false` 以外はすべて「真」です。\n文字列の \"false\" は真として扱われるため、`\"false\" || true` は `\"false\"` を返します。\nこれをif文に入れると、Rubyは「真」と判定して機能を有効にしてしまいます！\n\n正解パターン: `ENV['ENABLE_FEATURE'] != 'false'` など、明示的な変換が必要です。"
      },
      {
        title: "ケース2:破壊的メソッドとぼっち演算子",
        requirement: "ユーザー入力を正規化したい。「空白の除去(strip!)」と「小文字化(downcase!)」をチェーンさせたい。",
        code: "input = \"UserInput\"\nnormalized = input.strip!&.downcase!",
        question: "inputに余計な空白が **なかった** 場合、normalized の値は何になる？",
        choice_a: "\"userinput\" (String)",
        choice_b: "nil",
        choice_c: "\"UserInput\" (String)",
        answer: "B",
        explanation: "正解は B (nil) です。\n\n1. `input.strip!` が呼ばれます。空白がないので `nil` が返ります。\n2. `nil&.downcase!` が呼ばれます。`&.` なので `nil` が返ります。\n\n結果、`normalized` は `nil` になります。\nチェーンを使いたいなら、破壊的でない `strip.downcase` を使うか、`tap` を活用する必要があります。"
      },
      {
        title: "ケース3: 設定値の 3-State (ActiveModel)",
        requirement: "ある属性 `admin_flag` があります。この値は `true`, `false`, `nil` のいずれかを取り得ます。\n「値がセットされている（true または false）」かつ「nilではない」ことを判定したい。",
        code: "if object.admin_flag\n  # 処理\nend",
        question: "このコードで「falseがセットされている場合」は処理が実行される？",
        choice_a: "実行される",
        choice_b: "実行されない",
        answer: "B",
        explanation: "正解は B (実行されない) です。\n\n`false` はRubyにおいて「偽」なので、if文に入りません。\nしかし要件は「値がセットされている（falseも含む）」ことの判定です。\n\nこれを満たすには `!object.admin_flag.nil?` や、Railsなら `present?` ではなく `inclusion validation` など、文脈に応じた「存在チェック」が必要です。\n1.2の問題で扱う「デフォルト値の上書き」もこのパターンです。"
      },
      {
        title: "ケース4: ハッシュのキー検索 (API Client)",
        requirement: "APIレスポンスのハッシュ `response` から `:status` キーの値を取得したい。\nただし、`:status` キー自体が存在しない場合のみエラーにしたい（値が nil の場合はOK）。",
        code: "val = response[:status]\nraise 'Error' unless val",
        question: "このコードの問題点は？",
        choice_a: "問題ない",
        choice_b: "値が false や nil の時に誤ってエラーになる",
        choice_c: "シンボルではなく文字列でアクセスすべき",
        answer: "B",
        explanation: "正解は B です。\n\n`response[:status]` が `nil` を返したとき、それが「キーがないからnil」なのか「値がnilだからnil」なのか、この書き方では区別できません。\nまた、値が `false` の場合も `unless` に引っかかってしまいます。\n\n正解パターン: `response.key?(:status)` または `response.fetch(:status)` を使いましょう。"
      }
    ]
  end

  def run
    puts "\n=== 第1章 1.2 クイズ: True, False, and Nil ===\n"
    
    @questions.each_with_index do |q, i|
      puts "---------------------------------------------------"
      puts "Q#{i + 1}. #{q[:title]}"
      puts "---------------------------------------------------"
      puts "【要件】\n#{q[:requirement]}"
      puts "\n【コード】\n#{q[:code]}"
      puts "\n【問い】\n#{q[:question]}"
      
      puts "[A] #{q[:choice_a]}"
      puts "[B] #{q[:choice_b]}"
      puts "[C] #{q[:choice_c]}" if q[:choice_c]

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

    puts "---------------------------------------------------"
    puts "終了！ あなたのスコア: #{@score} / #{@questions.size}"
  end
end

Quiz.new.run