require 'rspec'
require 'benchmark'
require_relative '../../lib/ch01/item1_5'

RSpec.describe '1.5 配列、ハッシュ、セット（集合）を使い分ける' do
  let(:analyzer) { LogAnalyzer.new }

  it '監視対象ユーザーのログだけを正しく抽出できる（機能要件）' do
    logs = [
      { user_id: 'alice', action: 'login' },
      { user_id: 'bob', action: 'logout' },
      { user_id: 'charlie', action: 'view' }
    ]
    targets = ['alice', 'charlie']

    result = analyzer.filter_logs(logs, targets)
    expect(result.size).to eq(2)
    expect(result.map { |l| l[:user_id] }).to contain_exactly('alice', 'charlie')
  end

  it '大量データでも高速に動作する（非機能要件: パフォーマンス）' do
    # データ生成
    # ターゲット: 10,000人
    # ログ: 50,000件
    target_count = 10_000
    log_count = 50_000
    
    targets = (1..target_count).map { |i| "user_#{i}" }
    # ログの半数はターゲットユーザー、半数はその他
    logs = (1..log_count).map do |i|
      uid = i.even? ? "user_#{i % target_count + 1}" : "other_#{i}"
      { user_id: uid, action: 'test' }
    end

    time = Benchmark.realtime do
      analyzer.filter_logs(logs, targets)
    end

    # 改善前だと数秒かかる可能性があるが、Setを使えば 0.1秒未満で終わるはず
    # 余裕を持って 0.5秒以下を合格ラインとする
    puts "\nExecution Time: #{time.round(4)} sec"
    expect(time).to be < 0.5
  end
end
