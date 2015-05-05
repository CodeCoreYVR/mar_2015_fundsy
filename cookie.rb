class Cookie
  attr_accessor :object

  def eat
    "Eating"
  end

  def method_missing(method_name, *args, &block)
    object.send(:method_name)
    puts "you called #{method_name} but it's not defined"
  end
end
