class Object
  def self.const_missing(const)
    require "app/controllers/#{const.to_s.snake_case}"
    Object.const_get(const)
  end
end
