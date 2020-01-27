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
    return enum_for(:my_map) unless block_given?

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

  def my_inject(*args)
    arr = to_a
    from_start = 0
    sym = nil
    result = nil

    args.my_each do |argument|
      if argument.is_a? Numeric
        from_start = argument
      else
        sym = argument
      end
    end
    return enum_for(:my_inject) unless block_given? || !sym.nil?

    result = arr[from_start]
    arr.delete_at(from_start)

    if sym
      return arr[-1] if sym.to_s == '='

      arr.my_each do |element|
        result = result.send(sym.to_s, element)
      end
    else
      arr.my_each do |element|
        result = yield(result, element)
      end
    end

    result
  end
end

def multiply_elns(elements)
  elements.my_inject(1) do |element, items|
    element * items
  end
end
