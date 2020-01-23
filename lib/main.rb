module Enumerable
  def my_each
    element = 0
    while element < length
      yield(self[element])
      element += 1
    end
    self
  end

  def my_each_with_index
    element = 0
    while element < length
      yield(self[element], element)
      element += 1
    end
  end
end
