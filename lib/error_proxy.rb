class ErrorProxy < Array
  def initialize(error_array=[])
    super(error_array)
  end
  
  def full_messages
    self.map { |a| a.to_s }.join(", ")
  end
  
end
