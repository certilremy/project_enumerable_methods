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
    array = []
    if block_given?
      my_each { |a| array.push(a) if yield(a) }
      array
    else
      to_enum(:my_select)
    end
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

  def my_inject(given = self[0], symbol = nil)
    if block_given?
      given ||= 0
      index = 1
      while index < length
        given = yield(given, self[index])
        index += 1
      end
      given
    elsif (given.is_a? Symbol) || (symbol.is_a? Symbol)
      if given.is_a? Symbol
        case given
        when :+
          total = 0
          my_each { |x| total += x }
        when :-
          total = self[0]
          self[1..-1].my_each { |x| total -= x }
        when :*
          total = self[0]
          self[1..-1].my_each { |x| total *= x }
        when :/
          total = self[0]
          self[1..-1].my_each { |x| total /= x }
        end
        total
      elsif given.is_a? Numeric
        case symbol
        when :+
          to_a.my_each { |x| given += x }
        when :-
          to_a.my_each { |x| given -= x }
        when :*
          to_a.my_each { |x| given *= x }
        when :/
          to_a.my_each { |x| given /= x }
        end
        ind
      else
        "undefined method for #{ind}:#{ind.class}"
      end
    else
      'no block given (LocalJumpError)'
    end
  end
end

def multiply_elns(elements)
  elements.my_inject(1) do |element, items|
    element * items
  end
end
