# =============================================================================
# WhitePaper_6PeopleMenuVXAce
# =============================================================================
# Робить екран меню більш пристосованим під гру з 6 геро_їнями.
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

WP_6PEOPLE_SHOWLEVEL = true

WP_6PEOPLE_SHOWICONS = true
WP_6PEOPLE_ICONLINE = 3

WP_6PEOPLE_SHOWHP = true
WP_6PEOPLE_HPLINE = 1

WP_6PEOPLE_SHOWMP = true
WP_6PEOPLE_MPLINE = 2

# =============================================================================
# Кінець налаштувань
# =============================================================================
class Window_MenuStatus < Window_Selectable

  def item_height
    (height - standard_padding * 2) / 3
  end
  
  def draw_item(index)
    actor = $game_party.members[index]
    enabled = $game_party.battle_members.include?(actor)
    rect = item_rect(index)
    draw_item_background(index)
    draw_actor_face(actor, rect.x + 1, rect.y + 1, enabled)
    draw_actor_simple_status(actor, rect.x + 108, rect.y)
  end
  
  def draw_actor_simple_status(actor, x, y)
    draw_actor_name(actor, x, y)
    if (WP_6PEOPLE_SHOWLEVEL)
      draw_actor_level(actor, x + 80, y)
    end
    if (WP_6PEOPLE_SHOWICONS)
      draw_actor_icons(actor, x, y + line_height * WP_6PEOPLE_ICONLINE)
    end
    if (WP_6PEOPLE_SHOWHP)
      draw_actor_hp(actor, x, y + line_height * WP_6PEOPLE_HPLINE)
    end
    if (WP_6PEOPLE_SHOWMP)
      draw_actor_mp(actor, x, y + line_height * WP_6PEOPLE_MPLINE)
    end
  end
  def col_max
    return 2
  end
  def window_width
    Graphics.width
  end
  def window_height
    Graphics.height - fitting_height(2)
  end
end

class Scene_Menu < Scene_MenuBase
  def start
    super
    create_command_window
    create_status_window
  end
  def create_status_window
    @status_window = Window_MenuStatus.new(0, 0)
  end
end

class Window_MenuCommand < Window_Command
  def col_max
    return 4
  end
  def window_width
    Graphics.width
  end
  def window_height
    fitting_height(2)
  end
  def initialize
    super(0, Graphics.height - fitting_height(2))
    select_last
  end
end
