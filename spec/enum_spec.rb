require_relative '../lib/main.rb'

describe Enumerable do
  let(:arr) { [2, 3, 4] }
  let(:new_arr) { [1, 2, 2] }
  let(:empyt_arr) { [] }
  let(:empyt_hash) { {} }
  let(:oft) { [1, 5, 2] }
  let(:ofe) { [1, 5, 8] }

  let(:onilt) { [1, nil, 2] }
  let(:ofalset) { [1, false, 2] }
  let(:arrfour) { [1, 2, 4, 5] }
  let(:dogs) { %w[dog dog dog dog] }
  let(:hashnum) { { a: 1, b: 2, c: 0 } }

  describe '#my_each' do
    it 'return enumerator if block not given' do
      expect(arr.my_each.class).to eq(Enumerator)
    end

    it 'loops an entire array' do
      new_arr.my_each { |n| empyt_arr[n] = n + 2 }
      expect(empyt_arr).to eq([nil, 3, 4])
    end

    it 'returns product of each item in array' do
      expect(arr.my_each { |i| i * 2 }).to eql([4, 6, 8])
    end
  end

  describe 'my_each_with_index' do
    it 'block not given' do
      expect(oft.my_each_with_index.class).to eq(Enumerator)
    end

    it 'returns element without changes' do
      expect(new_arr.my_each_with_index { |n, _idx| n + 2 }).to eq([1, 2, 2])
    end

    it 'loops an entire array' do
      new_arr.my_each_with_index { |n, idx| empyt_arr[idx] = n + 2 }
      expect(empyt_arr).to eq([3, 4, 4])
    end

    it 'loops an entire hash' do
      hashnum.my_each_with_index { |(k, v), idx| empyt_hash[k] = v + idx }
      expect(empyt_hash).to eq(a: 1, b: 3, c: 2)
    end
  end

  describe 'my_select' do
    it 'return enumerator if no block not given' do
      expect(oft.my_select.class).to eq(Enumerator)
    end
    it 'selects array' do
      expect(arrfour.my_select { |n| n > 3 }).to eq([4, 5])
    end
    it 'return array of symbols :foo from array' do
      expect(%i[foo bar foo].my_select { |x| x == :foo }).to eql(%i[foo foo])
    end
  end

  describe 'my_all?' do
    it 'block not given, none of the elements false or nil' do
      expect(oft.my_all?).to eq(true)
    end
    it 'block not given, one of the elements false or nil' do
      expect(onilt.my_all?).to eq(false)
    end
    it 'block not given, one of the elements false' do
      expect(ofalset.my_all?).to eq(false)
    end
    it 'block not given, one of the elements nil' do
      expect(onilt.my_all?).to eq(false)
    end
    it 'pattern other than a Class or Regex' do
      expect(dogs.my_all?('dog')).to eq(true)
    end
    it 'pattern other than a Class or Regex, false' do
      expect(%w[dog dog cat dog].my_all?('dog')).to eq(false)
    end
    it 'class given, all the elements from that class' do
      expect(ofe.my_all?(Integer)).to eq(true)
    end
    it 'class given, not all the elements from that class' do
      expect(ofe.my_all?(String)).to eq(false)
    end
    it 'all with array false' do
      expect(arrfour.my_all? { |n| n > 3 }).to eq(false)
    end
    it 'all with array true' do
      expect(arrfour.my_all? { |n| n >= 1 }).to eq(true)
    end
    it 'all with hash false' do
      expect(hashnum.my_all? { |_k, v| v == 2 }).to eq(false)
    end
    it 'all with hash true' do
      expect(hashnum.my_all? { |_k, v| v.is_a? Integer }).to eq(true)
    end
  end

  describe 'my_any?' do
    it 'block not given, any of the elements not false or nil' do
      expect([nil, false, nil, 1].my_any?).to eq(true)
    end

    it 'block not given, all of the elements false or nil' do
      expect([nil, false, nil].my_any?).to eq(false)
    end

    it 'pattern other than a Class or Regex' do
      expect(dogs.my_any?('dog')).to eq(true)
    end

    it 'class given, any of the elements from that class' do
      expect([1, '5', 8].my_any?(Integer)).to eq(true)
    end

    it 'class given, none of the elements from that class' do
      expect(ofe.my_any?(String)).to eq(false)
    end

    it 'any with array true' do
      expect([1, 2, 4, 5].my_any? { |n| n > 3 }).to eq(true)
    end

    it 'any with array false' do
      expect([1, 2, 4, 5].my_any? { |n| n < 1 }).to eq(false)
    end

    it 'any with hash false' do
      expect(hashnum.my_any? { |_k, v| v > 20 }).to eq(false)
    end

    it 'any with hash true' do
      expect(hashnum.my_any? { |_k, v| v.is_a? Integer }).to eq(true)
    end
  end

  describe 'my_none?' do
    it 'a' do
      expect([nil].my_none?).to eq(true)
    end
    it 'b' do
      expect([nil, false, true].my_none?).to eq(false)
    end
    it 'pattern other than a Class or Regex' do
      expect(dogs.my_none?('cat')).to eq(true)
    end
    it 'pattern other than a Class or Regex' do
      expect(dogs.my_none?('dog')).to eq(false)
    end

    it 'Class, false' do
      expect(dogs.my_none?(String)).to eq(false)
    end
    it 'Class, true' do
      expect(dogs.my_none?(Integer)).to eq(true)
    end
    it 'none with array true' do
      expect(dogs.none? { |word| word.length == 4 }).to eq(true)
    end
    it 'none with array false' do
      expect(%w[ant bear cat].none? { |word| word.length >= 4 }).to eq(false)
    end
    it 'none with hash true' do
      expect(hashnum.my_none? { |_k, v| v == 7 }).to eq(true)
    end
    it 'none with hash false' do
      expect(hashnum.my_none? { |_k, v| v.is_a? Integer }).to eq(false)
    end
  end

  describe 'my_count' do
    it 'block not given array' do
      expect(oft.my_count).to eq(3)
    end
    it 'block not given hash' do
      expect({ a: 1, b: 2, c: 0, d: 5 }.my_count).to eq(4)
    end
    it 'counts array' do
      expect(oft.my_count { |n| n > 4 }).to eq(1)
    end
    it 'counts hash' do
      expect({ a: 1, b: 2, c: 0, d: 5 }.my_count { |_k, v| v < 5 }).to eq(3)
    end
    it 'count with params' do
      expect(oft.my_count(0)).to eq(0)
    end
    it 'count with params, equals' do
      expect(oft.my_count(2)).to eq(1)
    end
  end

  describe 'my_map' do
    it 'block and proc not given' do
      expect(oft.my_map.class).to eq(Enumerator)
    end

    it 'maps array with block' do
      expect(arrfour.my_map { |n| n + 2 }).to eq([3, 4, 6, 7])
    end

    it 'maps array with proc' do
      proc = proc { |n| n + 3 }
      expect(arrfour.my_map(proc)).to eq([4, 5, 7, 8])
    end

    it 'maps array with proc and block' do
      proc = proc { |n| n + 3 }
      expect(arrfour.my_map(proc) { |n| n + 2 }).to eq([4, 5, 7, 8])
    end

    it 'maps hash with block' do
      expect(hashnum.my_map { |k, v| k.to_s + v.to_s }).to eq(%w[a1 b2 c0])
    end

    it 'maps hash with proc' do
      proc = proc { |_k, v| v + 3 }
      expect(hashnum.my_map(proc)).to eq([4, 5, 3])
    end

    it 'maps hash with proc and block' do
      proc = proc { |_k, v| v + 3 }
      expect(hashnum.my_map(proc) { |_k, v| v + 2 }).to eq([4, 5, 3])
    end
  end

  describe 'my_inject' do
    let(:arr_2) { [1, 2, 3, 4] }
    it 'sums' do
      expect(arr_2.my_inject(:+)).to eq arr_2.inject(:+)
    end
    it 'sums with a starting point' do
      expect(arrfour.my_inject(10) { |sum, n| sum + n }).to eq(22)
    end
    it 'sums arrays' do
      expect(arrfour.my_inject { |sum, n| sum + n }).to eq(12)
    end
    it 'sums ranges' do
      expect((1..5).my_inject { |sum, n| sum + n }).to eq(15)
    end
    it 'substracts with a starting point' do
      expect(arrfour.my_inject(10) { |substract, n| substract - n }).to eq(-2)
    end
    it 'substracts arrays' do
      expect(arrfour.my_inject { |substract, n| substract - n }).to eq(-10)
    end
    it 'substracts ranges' do
      expect((1..5).my_inject { |substract, n| substract - n }).to eq(-13)
    end
    it 'multiplies with a starting point' do
      expect(arrfour.my_inject(10) { |multiplies, n| multiplies * n }).to eq(400)
    end
    it 'multiplies arrays' do
      expect(arrfour.my_inject { |multiplies, n| multiplies * n }).to eq(40)
    end
    it 'multiplies ranges' do
      expect((1..5).my_inject { |multiplies, n| multiplies * n }).to eq(120)
    end
    it 'divides with a starting point' do
      expect(arrfour.my_inject(10.2) { |divides, n| divides / n }).to eq(0.255)
    end
    it 'divides arrays' do
      expect(arrfour.my_inject { |divides, n| divides / n }).to eq(0)
    end
    it 'divides ranges' do
      expect((1..5).my_inject { |divides, n| divides / n }).to eq(0)
    end
  end
  describe 'multiply_els' do
    it 'using my_inject' do
      expect(multiply_els([2, 4, 5])).to eq(40)
    end
  end
end
