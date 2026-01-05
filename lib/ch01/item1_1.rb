class WordCategorizer
  attr_reader :categories

  def initialize
    # FIXME: This initialization causes unexpected behavior!
    @categories = Hash.new do |hash, key|
      hash[key] = []
    end
  end

  def add_word(category, word)
    @categories[category] << word
  end

  def list_category(category)
    @categories[category]
  end
end
