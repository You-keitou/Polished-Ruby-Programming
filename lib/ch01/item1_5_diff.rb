require 'set'

class Syncer
  # current_ids: 現在DBにあるIDリスト (Array)
  # new_ids: APIから来た最新IDリスト (Array)
  def sync(current_ids, new_ids)
    # FIXME: 配列のままだと、差分計算のたびにスキャンが走る可能性があります。
    # Setを活用して、一度の変換で効率よく計算してください。
    
    to_create = [] # new_ids にあって current_ids にない
    to_delete = [] # current_ids にあって new_ids にない
    to_keep   = [] # 両方にある

    current_ids_set = Set.new(current_ids)
    new_ids_set = Set.new(new_ids)

    to_create = new_ids_set - current_ids_set
    to_delete = current_ids_set - new_ids_set
    to_keep = new_ids_set & current_ids_set

    # 現状のナイーブな実装（遅い例）
    # to_create = new_ids - current_ids
    # to_delete = current_ids - new_ids
    # to_keep   = current_ids & new_ids
    
    # 戻り値は Array であること（呼び出し元の仕様）
    { create: to_create, delete: to_delete, keep: to_keep }
  end
end
