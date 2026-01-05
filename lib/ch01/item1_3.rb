require 'bigdecimal'

class BillSplitter
  TAX_RATE = 0.1

  def initialize(total_amount_excluding_tax)
    # FIXME: ここにバグがあります。
    # Float(100.5) を BigDecimal に渡しても、すでに誤差が含まれています。
    # OSS (Money gem) のように、文字列で渡すべきです。
    @total = BigDecimal(total_amount_excluding_tax.to_s)
  end

  def split(person_count)
    tax_multiplier = BigDecimal("1") + BigDecimal(TAX_RATE.to_s)
    total_with_tax = @total * tax_multiplier
    
    # FIXME: 割り切れない場合の処理が必要です。
    # 単純に / で割ると、無限小数が生成される可能性があります。
    # divメソッドやfloorメソッドを活用してください。
    (total_with_tax / person_count).floor
  end
end
