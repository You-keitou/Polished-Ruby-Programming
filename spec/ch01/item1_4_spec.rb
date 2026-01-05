require 'rspec'
require_relative '../../lib/ch01/item1_4'

RSpec.describe '1.4 シンボルと文字列の違いを理解する' do
  let(:raw_data) do
    {
      'user_id' => '12345',
      'name' => 'Alice',
      'role' => 'admin',     # 許可しない予定のキー
      'bio' => 'Hello ' * 10 # 長い文字列
    }
  end

  let(:params) { SafeParams.new(raw_data) }

  describe '#permit' do
    it '許可されたキーのみを保持し、許可されていないキーは除外する' do
      params.permit(:user_id, :name)
      
      expect(params[:user_id]).to eq('12345')
      expect(params[:name]).to eq('Alice')
      expect(params[:role]).to be_nil # role は許可していないので消える
    end

    it '文字列キーでpermitを指定しても動作する' do
      params.permit('user_id', 'name')
      expect(params[:user_id]).to eq('12345')
    end

    it '値の文字列は重複排除(dedup)される' do
      # メモリ最適化のテスト
      # Rubyの文字列リテラル最適化を回避するため、動的に生成した文字列を使用
      val1 = "duplicate_string" + ""
      val2 = "duplicate_string" + ""
      
      data = { 'k1' => val1, 'k2' => val2 }
      p = SafeParams.new(data)
      p.permit(:k1, :k2)

      # dedupされていれば、object_id (または内部の文字列プールID) が一致するはず
      # String#-@ を使うと frozen になることも確認条件の一つ
      expect(p[:k1].frozen?).to be true
      expect(p[:k2].frozen?).to be true
      
      # 異なるインスタンスだったものが、内容が同じなので同一IDに統合されているか？
      # (注意: VMの実装依存ですが、-@の効果を確認)
      expect(p[:k1].object_id).to eq(p[:k2].object_id)
    end
  end

  describe '#[] (access)' do
    before { params.permit(:user_id, :name) }

    it 'シンボルキーでアクセスできる' do
      expect(params[:user_id]).to eq('12345')
    end

    it '文字列キーでアクセスできる' do
      expect(params['user_id']).to eq('12345')
    end
  end
end
