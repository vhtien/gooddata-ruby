class Class
  def short_name
    self.name.split('::').last
  end
end
