#!/usr/bin/env ruby

class Quiz
  def initialize
    @score = 0
    @questions = [
      {
        title: "ケース1: HTTPリクエストの環境変数 (例: Rack)",
        requirement: "Webサーバーから受け取ったリクエスト情報（ヘッダー、パス、メソッドなど）を、アプリケーションの各ミドルウェアに渡す必要があります。このデータは単なる情報の「入れ物」であり、特定の振る舞い（メソッド）は持ちません。また、ミドルウェアが自由に値を書き換えることが許容されます。",
        choice_a: "組み込みクラス (Hash)",
        choice_b: "独自クラス (RequestEnv)",
        answer: "A",
        explanation: "正解は A (Hash) です。\n\nRubyのWebサーバーインターフェースである 'Rack' では、環境変数を単なる `Hash` として扱います。\nデータが「単なる入れ物」であり、特定のドメインロジックを持たず、柔軟性が求められる場合（キーが動的に増えるなど）は、Hashが適しています。\nただし、Railsの `ActionDispatch::Request` のように、便利なメソッドを提供したい段階になると、このHashをラップした独自クラスが登場します。"
      },
      {
        title: "ケース2: 金額の計算 (例: Money gem)",
        requirement: "ECサイトで商品の価格を扱います。数値（金額）と通貨（JPY, USD）のペアです。\n異なる通貨同士の足し算（100 JPY + 1 USD）はエラーにするか、換算する必要があります。\nまた、'100' と表示する際は、通貨に応じて '¥100' や '$1.00' とフォーマットする必要があります。",
        choice_a: "組み込みクラス (HashやArray)",
        choice_b: "独自クラス (Money)",
        answer: "B",
        explanation: "正解は B (独自クラス) です。\n\n`{ amount: 100, currency: 'USD' }` のようなHashで扱うと、通貨のチェックロジックがコードのあちこちに散らばってしまいます。\n「データ（金額と通貨）」と「振る舞い（足し算のルール、フォーマット）」が密接に関係している場合、それは独自クラスにするべき強力なサインです。\n有名な `money` gem も独自クラスを採用しています。"
      },
      {
        title: "ケース3: 2点間の座標 (例: ゲームや地図)",
        requirement: "2Dマップ上の位置を示す X座標 と Y座標 を持ちます。\nこのデータは大量（数万個）に生成される可能性があります。\n特別な計算メソッドは今のところ必要ありませんが、xとyという属性名は明確にしたいです。",
        choice_a: "組み込みクラス (Hash)",
        choice_b: "Struct (または Data)",
        choice_c: "完全な独自クラス",
        custom_choices: true,
        answer: "B",
        explanation: "推奨される正解は B (Struct/Data) です。\n\n単なるデータのコンテナであれば Hash でも可能ですが、`point[:x]` よりも `point.x` と書ける方がタイプミスを防げます。\nまた、大量に生成する場合、`Struct` や Ruby 3.2以降の `Data` は、完全なクラス定義を書くよりも簡潔で、メモリ効率も良い場合があります（特に `Data`）。\n「名前付きのデータ構造」が欲しいだけのときは、Structが組み込みと独自クラスの良い中間地点です。"
      },
      {
        title: "ケース4: APIのレスポンス解析 (例: API Client)",
        requirement: "外部のJSON APIを叩いて、レスポンスを受け取りました。\nレスポンスのフィールドは頻繁に変更される可能性があり、クライアント側ですべてのフィールドを事前に把握してマッピングするのはコストが高いです。\nとりあえずデータの中身をログに出したり、特定のキーだけ参照できれば十分です。",
        choice_a: "組み込みクラス (Hash / JSON.parseの結果)",
        choice_b: "独自クラス (ResponseModel)",
        answer: "A",
        explanation: "正解は A (Hash) です。\n\n構造が不安定、あるいは未知のデータ構造を扱う場合、厳密な独自クラス（Struct含む）を定義すると、フィールドが増減するたびに修正が必要になり、メンテナンスコストが跳ね上がります。\nこのような「境界」のデータ処理や、一時的なデータ保持には、柔軟な Hash が最適です。"
      }
    ]
  end

  def run
    puts "\n=== 第1章 1.1 クイズ: Core vs Custom ===\n"
    puts "要件を読んで、適切な設計判断を下してください。\n\n"

    @questions.each_with_index do |q, i|
      puts "---------------------------------------------------"
      puts "Q#{i + 1}. #{q[:title]}"
      puts "---------------------------------------------------"
      puts "【要件】"
      puts q[:requirement]
      puts "\n"
      
      if q[:custom_choices]
        puts "[A] #{q[:choice_a]}"
        puts "[B] #{q[:choice_b]}"
        puts "[C] #{q[:choice_c]}"
      else
        puts "[A] #{q[:choice_a]}"
        puts "[B] #{q[:choice_b]}"
      end

      print "\nあなたの選択 (A/B/C) > "
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
    if @score == @questions.size
      puts "完璧です！設計の勘所を完全に理解していますね。"
    else
      puts "復習して、またチャレンジしてください！"
    end
  end
end

Quiz.new.run
