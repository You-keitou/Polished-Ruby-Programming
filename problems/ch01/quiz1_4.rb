#!/usr/bin/env ruby
# frozen_string_literal: true

require 'objspace'

class SymbolStringQuiz
  def initialize
    @score = 0
    @questions = [
      {
        title: "ケース1: 外部入力とシンボル化 (Symbol DoS)",
        requirement: "Web APIのエンドポイントで、JSONのキーをシンボルに変換して扱いたい。
`JSON.parse(payload, symbolize_names: true)` を使用している。",
        question: "このコードがセキュリティレビューで『修正必須（Critical）』と判断される理由は？",
        choice_a: "シンボルの生成は文字列より遅いため、レイテンシが悪化する",
        choice_b: "攻撃者がランダムなキーを持つJSONを大量に送信することで、メモリを枯渇させられる (DoS)",
        choice_c: "Ruby 3.0以降ではシンボルは即座にGCされるため、実は問題ない",
        answer: "B",
        explanation: "正解は B です。

Ruby 2.2以降、動的に生成された一部のシンボルはGCされますが、それでも文字列に比べてコストが高く、回収のタイミングも異なります。
外部からの任意の入力を無制限にシンボル化することは、依然として **Symbol DoS** 脆弱性につながります。
Railsの `params` が `HashWithIndifferentAccess` を使い、内部で文字列としてキーを保持するのはこのためです。"
      },
      {
        title: "ケース2: フリーズされた文字列 (Frozen String Literal)",
        requirement: "ファイルの先頭に `# frozen_string_literal: true` を書いた。",
        code: "a = \"hello\"
b = \"hello\"
puts a.object_id == b.object_id",
        question: "このコードの出力は？",
        choice_a: "true (同じオブジェクトID)",
        choice_b: "false (異なるオブジェクトID)",
        answer: "A",
        explanation: "正解は A です。

`frozen_string_literal: true` が有効な環境では、ソースコード中の文字列リテラルは自動的に freeze され、同じ内容のリテラルは **同一のオブジェクトインスタンス** を共有します（Intern化）。
これにより、メモリ使用量が劇的に削減されます。"
      },
      {
        title: "ケース3: 文字列の重複排除 (String Deduplication)",
        requirement: "CSVファイルから大量のデータを読み込む。'status' カラムには 'active', 'inactive' などの値が入るが、これらはリテラルではなくファイルから読み込んだ動的な文字列である。",
        code: "status1 = csv_row['status'] # 'active' (from file)\nstatus2 = csv_row_next['status'] # 'active' (from file)",
        question: "これらをシンボル化せずに、かつメモリ効率よく（同じオブジェクトとして）扱いたい。Ruby 2.5以降で使えるテクニックは？",
        choice_a: "status1.freeze",
        choice_b: "-status1 (単項マイナス演算子)",
        choice_c: "status1.dedup",
        answer: "B",
        explanation: "正解は B です。

Ruby 2.5で導入された `String#-@` (単項マイナス) は、文字列の内容が既にインタプリタ内部のプールに存在すればそのオブジェクトを返し、なければ freeze して登録します。
これを **String Deduplication** と呼びます。
`freeze` は単にオブジェクトを変更不可にするだけで、重複排除（メモリ共有）までは保証しません（VMの実装依存ですが、明示的な `-@` が確実です）。"
      },
      {
        title: "ケース4: ハッシュのキー検索速度",
        requirement: "巨大なハッシュ（100万エントリ）がある。キーはすべて短い文字列（5文字程度）。",
        question: "検索速度 `hash['key']` (Stringキー) と `hash[:key]` (Symbolキー) の比較として正しいのは？",
        choice_a: "Symbolキーの方が圧倒的に速い（整数比較のため）",
        choice_b: "Stringキーの方が速い",
        choice_c: "最近のRuby (2.2+) では、短い文字列であれば有意な差はない",
        answer: "C",
        explanation: "正解は C です（Aを選んだ人も部分点）。

伝統的には「シンボルは整数ID比較だから速い」と言われてきましたが、近年のRubyでは文字列ハッシュの最適化（MurmurHashなど）が進んでおり、特に短い文字列ではベンチマーク上の差は無視できるレベルに縮まっています。
したがって、「速度のためだけに」無理してシンボルを使う必要性は薄れています（メモリ効率の観点の方が重要です）。"
      }
    ]
  end

  def run
    puts "\n=== 第1章 1.4 クイズ: Advanced Symbols & Strings ===\n"
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

SymbolStringQuiz.new.run
