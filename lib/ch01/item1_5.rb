require 'set'

class LogAnalyzer
  # logs: ログデータの配列 [{user_id: "u1", action: "login"}, ...]
  # target_user_ids: 監視対象のユーザーID配列 ["u1", "u500", ...]
  def filter_logs(logs, target_user_ids)
    # FIXME: パフォーマンス・チューニングが必要です。
    # 現在の実装は O(N * M) で、データ量が多いと死ぬほど遅いです。
    # Set を使って O(N) にしてください。

    target_user_ids_set = Set.new(target_user_ids)
    # ヒント: target_user_ids を Set に変換するコストは O(M) です。
    # その後の検索は O(1) になります。
    
    logs.select do |log|
      target_user_ids_set.include?(log[:user_id])
    end
  end
end
