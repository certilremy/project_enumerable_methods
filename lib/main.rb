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

  def my_all?
    my_each do |a|
      return false unless yield(a)
    end
    true
  end

  def my_any?
    exist = false
    my_each do |element|
      exist = yield(element)
      break if exist
    end
    exist
  end
end
