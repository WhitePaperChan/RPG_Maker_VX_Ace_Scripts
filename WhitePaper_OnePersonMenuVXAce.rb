# =============================================================================
# WhitePaper_OnePersonMenuVXAce
# =============================================================================
# Робить екран меню більш пристосованим під гру з одн_ією геро_їнею.
#
# Портрет геро_їні має знаходитися в папці Pictures, мати ту ж назву, що й 
# графіка на карті в базі даних, і бути в форматі png.
# 
# Технічні подробиці:
# Цей скрипт:
# * змінює метод command_personal класу Scene_Menu,
# * змінює метод draw_item класу Window_MenuStatus,
# * змінює метод item_height класу Window_MenuStatus,
# * змінює метод draw_actor_simple_status класу Window_MenuStatus,
# * додає метод draw_actor_exp класу Window_MenuStatus,
# * додає метод portrait_name класу Window_MenuStatus,
# * додає метод draw_actor_portrait класу Window_MenuStatus,
# * додає метод draw_parameters класу Window_MenuStatus,
# * додає метод draw_equipments класу Window_MenuStatus.
#
# =============================================================================
# Ліцензія
# ==============================================================================
#
# Цей скрипт розповсюджується за ліцензією MIT-0 (MIT No Attribution License)
#
# MIT No Attribution
#
# Copyright 2023 WhitePaperChan
#
# Permission is hereby granted, free of charge, to any person obtaining a copy 
# of this software and associated documentation files (the "Software"), to deal 
# in the Software without restriction, including without limitation the rights 
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
# copies of the Software, and to permit persons to whom the Software is 
# furnished to do so.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
# SOFTWARE. 
# =============================================================================

# =============================================================================
# Початок налаштувань
# =============================================================================

# =============================================================================
# Зсув графіки портрету у пікселях
# =============================================================================

WP_ONEPERSON_OFFSET_X = 20
WP_ONEPERSON_OFFSET_Y = 25

# =============================================================================
# Текст полоси досвіду
# =============================================================================

WP_ONEPERSON_EXP_TEXT = "EXP"

# =============================================================================
# Кольори полоси досвіду
# =============================================================================

WP_ONEPERSON_EXP_GAUGE_COLOR1 = 5
WP_ONEPERSON_EXP_GAUGE_COLOR2 = 13

# =============================================================================
# Кінець налаштувань
# =============================================================================
class Scene_Menu < Scene_MenuBase
  def command_personal
    on_personal_ok
  end
end

class Window_MenuStatus < Window_Selectable
  def draw_item(index)
    actor = $game_party.members[index]
    enabled = $game_party.battle_members.include?(actor)
    rect = item_rect(index)
    draw_item_background(index)
    draw_actor_portrait(actor)
    draw_actor_simple_status(actor, rect.x + 1, rect.y + 1)
    draw_parameters(rect.x + 1, rect.y + line_height * 4, actor)
    draw_equipments(rect.x + 1, rect.y + line_height * 11, actor)
  end
  
  def item_height
    height - standard_padding * 2
  end
  
  def draw_actor_simple_status(actor, x, y)
    draw_actor_name(actor, x, y)
    draw_actor_level(actor, x, y + line_height * 1)
    draw_actor_icons(actor, x, y + line_height * 2)
    draw_actor_class(actor, x + 100, y)
    draw_actor_hp(actor, x + 100, y + line_height * 1)
    draw_actor_exp(actor, x + 100, y + line_height * 2)
    draw_actor_mp(actor, x + 230, y + line_height * 1)
    draw_actor_tp(actor, x + 230, y + line_height * 2)
  end
  
  def draw_actor_exp(actor, x, y, width = 124)
    s1 = actor.exp - actor.current_level_exp
    s2 = actor.max_level? ? actor.exp : actor.next_level_exp - actor.current_level_exp
    draw_gauge(
      x, 
      y, 
      width, 
      s1.to_f / s2, 
      text_color(WP_ONEPERSON_EXP_GAUGE_COLOR1), 
      text_color(WP_ONEPERSON_EXP_GAUGE_COLOR2))
    change_color(system_color)
    draw_text(x, y, 50, line_height, WP_ONEPERSON_EXP_TEXT)
    change_color(tp_color(actor))
    draw_current_and_max_values(x, y, width, 
    actor.exp - actor.current_level_exp, 
    actor.next_level_exp - actor.current_level_exp,
      normal_color, normal_color)
  end
  
  def portrait_name(actor)
    actor.face_name + "-" + (actor.face_index + 1).to_s
  end
  
  def draw_actor_portrait(actor)
    if File.exists?("Graphics\\Pictures\\" + portrait_name(actor) + ".png")
      bitmap = Cache.picture(portrait_name(actor))
      rect = Rect.new(0, 0, bitmap.width, bitmap.height)
      contents.blt(
        self.width - bitmap.width - standard_padding + WP_ONEPERSON_OFFSET_X, 
        self.height - bitmap.height - standard_padding + WP_ONEPERSON_OFFSET_Y, 
        bitmap, 
        rect, 
        255)
      bitmap.dispose
    end
  end
  
  def item_max
    1
  end
  
  def draw_parameters(x, y, actor)
    6.times {|i| draw_actor_param(actor, x, y + line_height * i, i + 2) }
  end
  
  def draw_equipments(x, y, actor)
    actor.equips.each_with_index do |item, i|
      draw_item_name(item, x, y + line_height * i)
    end
  end
end