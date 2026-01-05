class ConfigManager
  def initialize(defaults = {})
    @defaults = defaults
    @user_configs = {}
  end

  def set(key, value)
    @user_configs[key] = value
  end

  # 要件:
  # 1. @user_configs にキーがあれば、その値を返す (true/false/nil 全て許容)
  # 2. @user_configs になければ、@defaults の値を返す
  # 3. どちらにもなければ nil を返す
  def enabled?(key)
    # FIXME: OSSで学んだ Hash#fetch や Hash#key? を活用して、
    # 明示的な false や nil が正しく「設定値」として扱われるように修正してください。
    @user_configs.fetch(key, @defaults[key])
  end
end