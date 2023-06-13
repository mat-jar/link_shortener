class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end

  private_class_method :new

end
