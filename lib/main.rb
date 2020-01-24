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

  def my_select
    new_array = []

    my_each do |a|
      yield(a) ? new_array.push(a) : new_array
    end
  end
end
