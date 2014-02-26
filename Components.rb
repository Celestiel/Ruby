#==============================================================================
# ** Tab_Selection
#------------------------------------------------------------------------------
# 
#==============================================================================
class Tab_Selection
  #--------------------------------------------------------------------------
  # * Include 
  #--------------------------------------------------------------------------
  include GUI::Display_Manager
  #--------------------------------------------------------------------------
  # * Attr_accessor
  #--------------------------------------------------------------------------
  attr_accessor :id
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize(list,x,y,vw,l=1)
    @list = list
    @id = 0
    @x = x
    @y = y
    @vw = vw
    @l = l
    @column = (@list.size/@l.to_f).ceil
    @vh = l*16
    @w = @vw / @column
    initialize_viewport
    build
  end
  #--------------------------------------------------------------------------
  # * Initialize_viewport
  #--------------------------------------------------------------------------
  def initialize_viewport
    @viewport = Viewport.new(@x,@y,@vw,@vh)
    @bg = Plane.new(@viewport)
    @bg.bitmap = create_bg
  end
  #--------------------------------------------------------------------------
  # * create_bg
  #--------------------------------------------------------------------------
  def create_bg
    bmp = Bitmap.new(@w, 16)
    bmp.fill_rect(0,0,@w, 16,Uniq::Color::Dark_Blue)
    bmp.fill_rect(1,1,@w-1,15,Uniq::Color::Ligth_Blue2)
    bmp
  end
  #--------------------------------------------------------------------------
  # * create_selector_bg
  #--------------------------------------------------------------------------
  def create_selector_bg
    bmp = Bitmap.new(@w,16)
    bmp.fill_rect(0,0,@w, 16, Uniq::Color::Dark_Blue)
    bmp.font = Uniq::Font::Selector
    bmp
  end
  #--------------------------------------------------------------------------
  # * Create Tab
  #--------------------------------------------------------------------------
  def create_tab
    @tabs = Sprite.new(@viewport)
    @tabs.z = 0xfffff9
    @tabs.bitmap = Bitmap.new(@vw,@vh)
    @tabs.bitmap.font = Uniq::Font::Basic
    @list.each_with_index do |texte,i|
      @tabs.bitmap.draw_text((i % @column * @w)+2,(i / @column *16),@w-4,16,texte)
    end
  end
  #--------------------------------------------------------------------------
  # * Create Selector
  #--------------------------------------------------------------------------
  def create_selector
    @selector = Sprite.new(@viewport)
    @selector.z = 0xffffff
    update_selector
  end
  #--------------------------------------------------------------------------
  # * Update Slector
  #--------------------------------------------------------------------------
  def update_selector
    @selector.bitmap = create_selector_bg
    @selector.x = @id % @column * @w
    @selector.y = @id / @column *16
    @selector.bitmap.draw_text(2,0,@w-4,16,@list[@id])
  end
  #--------------------------------------------------------------------------
  # * Build
  #--------------------------------------------------------------------------
  def build
    create_tab
    create_selector
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    if @viewport.rect.trigger?(:mouse_left)
      x = (Mouse.x - @x) / @w
      y = (Mouse.y - @y) / 16
      @id = @column * y + x
      @id = @list.size-1 if @id > @list.size-1
      update_selector
    end
    @viewport.update
  end
end
#==============================================================================
# ** Scrollable_List
#------------------------------------------------------------------------------
# Thanks: Nuki
# Note: List is a Array
#==============================================================================
class Scrollable_List
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  include GUI::Display_Manager
  attr_accessor :id
  def initialize(list,x,y,vw,vh)
    @list = list
    @x = x
    @y = y
    @vw = vw
    @vh = vh
    @id = 0
    build
  end
  #--------------------------------------------------------------------------
  # * Create Background Plane
  #--------------------------------------------------------------------------
  def create_bg
    bmp = Bitmap.new(@w,32)
    bmp.fill_rect(0,0,@w,16,Uniq::Color::Ligth_Blue1)
    bmp.fill_rect(0,16,@w,16,Uniq::Color::Ligth_Blue2)
    bmp
  end
  #--------------------------------------------------------------------------
  # * Create Viewport
  #--------------------------------------------------------------------------
  def create_view_port
    @viewport_list = GUI::Scrollable_Viewport.new(@x, @y, @vw, @vh)
    @w = (@list.size * 16) > @viewport_list.height ? @vw-16 : @vw
    @rect = Rect.new(@x,@y,@w,@vh)
    @bg = Plane.new(@viewport_list)
    @bg.bitmap = create_bg
  end
  #--------------------------------------------------------------------------
  # * Create List
  #--------------------------------------------------------------------------
  def create_list
    spr = Sprite.new(@viewport_list)
    spr.z = 0xfffff9
    spr.bitmap = Bitmap.new(@w,@list.size*16)
    spr.bitmap.font = Uniq::Font::Basic
    @list.each_with_index do |m, i|
      spr.bitmap.draw_text(0,i*16,@w,16,m)
    end
    @sp_list = spr
  end
  #--------------------------------------------------------------------------
  # Build List
  #--------------------------------------------------------------------------
  def build
    create_view_port
    create_list
    create_selector
  end
  #--------------------------------------------------------------------------
  # Create Selector
  #--------------------------------------------------------------------------
  def create_selector
    spr = Sprite.new(@viewport_list)
    spr.z = 0xffffff
    spr.bitmap = Bitmap.new(@w,16)
    spr.bitmap.font = Uniq::Font::Selector
    @selector = spr
    update_selector
  end
  #--------------------------------------------------------------------------
  # Update Selector
  #--------------------------------------------------------------------------
  def update_selector
    @selector.y = 16 * @id
    @selector.bitmap.fill_rect(0,0,@w,16,Uniq::Color::Dark_Blue)
    @selector.bitmap.draw_text(0,0,@w,16,@list[@id])
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    @viewport_list.update
    if @rect.trigger?(:mouse_left)
      tb_index = @viewport_list.vertical.index
      tb_max = @viewport_list.vertical.max
      #L'ID est calculée à partir de la position du curseur sur le sprite
      id = (@sp_list.height*tb_index/tb_max + Mouse.y - @y) / 16
      @id = id if id < @list.size
      update_selector
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    @selector.dispose
    @sp_list.dispose
    @bg.dispose
    @viewport_list.dispose
  end
end
