require 'rspec'
require_relative '../../lib/ch01/item1_2'

RSpec.describe '1.2 true、false、nilを活用する' do
  let(:manager) { ConfigManager.new(dark_mode: true, verbose: false, theme: 'light') }

  describe '#enabled?' do
    it 'ユーザーが false を設定した場合、デフォルトの true よりも優先される' do
      manager.set(:dark_mode, false)
      expect(manager.enabled?(:dark_mode)).to be false
    end

    it 'ユーザーが nil を設定した場合、デフォルトの値よりも優先されて nil になる' do
      # 非常に重要なケース: 「設定をあえて空(nil)にする」という意思表示
      manager.set(:theme, nil)
      expect(manager.enabled?(:theme)).to be_nil
    end

    it 'ユーザー設定がない場合、デフォルトの false が正しく返る' do
      expect(manager.enabled?(:verbose)).to be false
    end

    it 'ユーザー設定もデフォルト設定もない場合、nil を返す' do
      expect(manager.enabled?(:unknown)).to be_nil
    end

    it '破壊的メソッドの nil 返却を考慮したチェーンのテスト（応用）' do
      # OSSで見たような nil 安全性の確認
      manager.set(:prefix, "  [DEBUG]  ")
      # 設定値を加工して取得するようなユースケース
      val = manager.enabled?(:prefix)&.strip! || "NO_PREFIX"
      expect(val).to eq("[DEBUG]")
    end
  end
end