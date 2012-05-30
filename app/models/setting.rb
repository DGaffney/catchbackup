class Setting < ActiveRecord::Base
  before_save :marshal_value
  
  def marshal_value
    self.value = [ Marshal.dump(value) ].pack('m')
  end
  
  def actual_value
    return  Marshal.load(value.unpack('m').first)
  end
  
  def self.grab(key)
    self.find_by_key(key).actual_value
  end
  
end
