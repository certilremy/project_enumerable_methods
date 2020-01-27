module Enumerable
  def my_each
    return unless block_given?

    element = 0
    while element < length
      yield(self[element])
      element += 1
    end
    self
  end

  def my_each_with_index
    return unless block_given?

    element = 0
    while element < length
      yield(self[element], element)
      element += 1
    end
  end

  def my_select
    new_array = []
    return unless block_given?

    my_each do |a|
      yield(a) ? new_array.push(a) : new_array
    end
  end

  def my_all?
    return unless block_given?

    my_each do |a|
      return false unless yield(a)
    end
    true
  end

  def my_any?
    return unless block_given?

    exist = false
    my_each do |element|
      exist = yield(element)
      break if exist
    end
    exist
  end

  def my_none?
    return unless block_given?

    (my_any? { |i| yield(i) == true }) != true
  end

  def my_count(number = nil)
    return total = lenght unless block_given?

    total = 0
    if number
      my_each { |element| total += 1 if element == number }
    elsif block_given?
      my_each { |element| total += 1 if yield(element) }
    else
      total = length
    end
    total
  end

  def my_map(proc = nil)
    new_arr = []
    return unless block_given?

    if proc
      my_each do |element|
        new_arr << proc.call(element)
      end
    elsif proc.nil? && block_given?
      my_each do |element|
        new_arr << yield(element)
      end
    end
    new_arr
  end

  def my_inject(s_t)
    return unless block_given?

    my_each { |i| s_t = yield(s_t, i) }
    s_t
  end
end

def multiply_elns(elements)
  elements.my_inject(1) do |element, items|
    element * items
  end
end
