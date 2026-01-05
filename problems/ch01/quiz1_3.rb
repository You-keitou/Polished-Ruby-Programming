#!/usr/bin/env ruby
# frozen_string_literal: true

class NumericQuiz
  def initialize
    @score = 0
    @questions = [
      {
        title: "ケース1: 消費税の計算",
        requirement: "100円の商品の10%の消費税を計算し、合計金額を出したい。
正確性が何よりも重要です。",
        code: "total = 100 * 1.1",
        question: "この計算で `1.1` (Float) を使う際のリスクは？",
        choice_a: "全く問題ない",
        choice_b: "浮動小数点の誤差により、計算結果が 110.00000000000001 のようになる可能性がある",
        choice_c: "処理速度が遅すぎる",
        answer: "B",
        explanation: "正解は B です。

Float（浮動小数点）は2進数で計算するため、10進数の 0.1 などを正確に表現できません。
お金の計算に Float を使うのは厳禁です。Rubyでは `BigDecimal` を使うのが正解です。"
      },
      {
        title: "ケース2: 巨大な整数の計算",
        requirement: "宇宙の星の数のような、64bit整数（2^64）を超える非常に大きな数値を扱いたい。",
        code: "large_num = 2**128",
        question: "Rubyでこの数値を扱うために必要な特別なクラスや設定は？",
        choice_a: "何も必要ない（Integerクラスが自動で多倍長整数として扱う）",
        choice_b: "BigInt クラスを require する必要がある",
        choice_c: "Rubyでは 64bit を超える数値は扱えない",
        answer: "A",
        explanation: "正解は A です。

Rubyの `Integer` は、数値の大きさに応じて自動的にメモリを割り当てる「多倍長整数」です。
昔のRubyには Fixnum と Bignum がありましたが、現在は `Integer` に統合され、ユーザーはサイズを気にせず計算できます。"
      },
      {
        title: "ケース3: 比較の罠",
        code: "x = 0.1 + 0.2\nputs x == 0.3",
        question: "このコードの出力結果はどうなる？",
        choice_a: "true",
        choice_b: "false",
        answer: "B",
        explanation: "正解は B (false) です。

実際に実行すると `0.1 + 0.2` は `0.30000000000000004` になります。
Float 同士を `==` で比較するのは非常に危険です。"
      },
      {
        title: "ケース4: 速度と精度のトレードオフ",
        requirement: "3Dゲームの座標計算や、物理シミュレーションで1秒間に何万回も計算を行いたい。
わずかな誤差は許容できるが、計算速度が極めて重要。",
        question: "どの型を使うべき？",
        choice_a: "BigDecimal",
        choice_b: "Rational (有理数)",
        choice_c: "Float",
        answer: "C",
        explanation: "正解は C (Float) です。

`BigDecimal` は正確ですが、ソフトウェアで計算するため低速です。
一方、`Float` はCPUの浮動小数点演算ユニット(FPU)で直接処理されるため、圧倒的に高速です。
「絶対的な正確さ」か「速度」か、用途に応じた使い分けがプロの仕事です。"
      }
    ]
  end

  def run
    puts "\n=== 第1章 1.3 クイズ: Numeric Types ===\n"
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

NumericQuiz.new.run
