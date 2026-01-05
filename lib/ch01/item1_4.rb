# frozen_string_literal: true
class SafeParams
  def initialize(raw_params)
    @raw_params = raw_params
    @permitted_params = {}
  end

  # 許可するキーのリストを受け取り、フィルタリングして内部に保持する
  def permit(*keys)
    # FIXME: ここを実装してください。
    # 1. raw_params から keys に含まれるものだけを抽出
    # 2. キーはシンボルに変換して保持
    # 3. 値が文字列なら dedup (-@) する
    @permitted_params = {} # placeholder

    keys.each do |key|
      string_key = key.to_s
      next unless @raw_params.key?(string_key)

      row_value = @raw_params[string_key]
      row_value = -row_value if row_value.is_a? String
      @permitted_params[key.to_sym] = row_value
    end
  end

  # シンボルでも文字列でも値を取得できるようにする
  def [](key)
    # FIXME: キーが文字列で来てもシンボルで来ても @permitted_params から引けるようにする
    @permitted_params[key.to_sym]
  end

  # テスト用: 内部データを確認するメソッド
  def to_h
    @permitted_params
  end
end
