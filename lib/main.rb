module Enumerable
  def my_each
    return enum_for(:my_each) unless block_given?

    return_array = to_a

    (0...return_array.length).each do |i|
      return_array[i] = yield(return_array[i])
    end
    return_array
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    if self.class == Array
      0.upto(length - 1) do |index|
        yield(self[index], index)
      end
    elsif self.class == Hash
      keys = self.keys
      keys.length.times do |i|
        key = keys[i]
        value = self[key]
        key_value = [key, value]
        yield(key_value, i)
      end
    end
    self
  end

  def my_select
    return enum_for(:my_select) unless block_given?

    return_array = []

    my_each do |element|
      return_array << element if yield(element)
    end

    return_array
  end

  def my_all?(given = nil)
    if block_given?
      my_each { |x| return false unless yield(x) }
      true
    elsif given
      if given.is_a? Regexp
        my_each { |x| return false unless x =~ given }
      elsif given.is_a? Class
        my_each { |x| return false unless x.is_a? given }
      else
        my_each { |x| return false unless x == given }
      end
    else
      my_each { |x| return false unless x }
    end
    true
  end

  def my_any?(given = nil)
    if block_given?
      my_each { |x| return true if yield(x) }
      false
    elsif given
      if given.is_a? Regexp
        my_each { |x| return true if x =~ given }
      elsif given.is_a? Class
        my_each { |x| return true if x.is_a? given }
      else
        my_each { |x| return true if x == given }
      end
    else
      my_each { |x| return true if x }
    end
    false
  end

  def my_none?(given = nil)
    if block_given?
      my_each { |x| return false if yield(x) }
      true
    elsif given
      if given.is_a? Regexp
        my_each { |x| return false if x =~ given }
      elsif given.is_a? Class
        my_each { |x| return false if x.is_a? given }
      else
        my_each { |x| return false if x == given }
      end
    else
      my_each { |x| return false if x }
    end
    true
  end

  def my_count(number = nil)
    total = 0
    if block_given?
      my_each { |x| total += 1 if yield(x) }
    elsif number.nil?
      my_each do |_|
        total += 1
      end
    else
      my_each { |x| total += 1 if number == x }
    end
    total
  end
  
  def my_map(proc = nil)
    return to_enum(:my_map) if !block_given? && proc.nil?

    map_items = []

    if !proc.nil?
      my_each_with_index do |n, i|
        map_items [i] = proc.call(n)
      end
    else
      my_each_with_index do |n, i|
        map_items [i] = yield n
      end
    end
    map_items
  end

  def my_inject(*args)
    arr = to_a.dup
    if args[0].nil?
      result = arr.shift
    elsif args[1].nil? && !block_given?
      symbol = args[0]
      result = arr.shift
    elsif args[1].nil? && block_given?
      result = args[0]
    else
      result = args[0]
      symbol = args[1]
    end
    arr[0..-1].my_each do |i|
      result = if symbol
                 result.send(symbol, i)
               else
                 yield(result, i)
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
