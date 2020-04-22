module DesignSystem::ViewRenderer
  def self.render(file, locals = {})
    path = File.expand_path(File.dirname(file))
    engine = Haml::Engine.new(File.read("#{path}/template.haml"))
    engine.render(Object.new, locals) 
  end
end

