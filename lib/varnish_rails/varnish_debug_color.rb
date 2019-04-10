class String

  def varnish_debug_color
    "\e[#{33}m#{self}\e[0m"
  end
  
end