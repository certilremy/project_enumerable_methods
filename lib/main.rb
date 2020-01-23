module Enumerable
  def my_each
    element = 0
    while element < self.length
      yield(self[element])
      element += 1
    end
    self
  end
end
