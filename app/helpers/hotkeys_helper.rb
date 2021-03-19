module HotkeysHelper
  def hotkeys
    {
      q: 'body->command#spell_q',
      w: 'body->command#spell_w',
      e: 'body->command#spell_e',
      r: 'body->command#spell_r',
    }.to_json
  end
end
