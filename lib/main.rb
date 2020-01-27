module Enumerable
  def my_each
    return enum_for(:my_each) unless block_given?

    element = 0
    while element < length
      yield(self[element])
      element += 1
    end
    self
  end

  def my_each_with_index
    return enum_for(:my_each_with_index) unless block_given?

    element = 0
    while element < length
      yield(self[element], element)
      element += 1
    end
  end

  def my_select
    return enum_for(:my_select) unless block_given?

    new_array = []

    my_each do |a|
      yield(a) ? new_array.push(a) : new_array
    end
  end

  def my_all?(given = nil)
    if given.class == Regexp
      my_each do |element|
        return false unless element.match(given)
      end
    elsif given
      my_each do |element|
        return false unless element.is_a?(given)
      end
    elsif block_given?
      my_each do |element|
        return false unless yield(element)
      end
    else
      my_each do |element|
        return false unless element
      end
    end

    true
  end

  def my_any?(given = nil)
    if given.class == Regexp
      my_each do |element|
        return true unless element.match(given).nil?
      end
    elsif given
      my_each do |element|
        return true if element.is_a?(given)
      end
    elsif block_given?
      my_each do |element|
        return true if yield(element)
      end
    else
      my_each do |element|
        return true if element
      end
    end

    false
  end

  def my_none?(given = nil)
    if given.is_a?(Regexp)
      my_each do |element|
        return false unless element.match(given).nil?
      end
    elsif given
      my_each do |element|
        return false if element.is_a?(given)
      end
    elsif block_given?
      my_each do |element|
        return false if yield(element)
      end
    else
      my_each do |element|
        return false if element
      end
    end

    true
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
