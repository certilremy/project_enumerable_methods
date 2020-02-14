require_relative '../lib/main.rb'

describe Enumerable do
  let(:arr) { [2, 3, 4] }
  let(:new_arr) { [1, 2, 2] }
  let(:empyt_arr) { [] }
  let(:empyt_hash) { {} }

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
      expect([1, 5, 2].my_each_with_index.class).to eq(Enumerator)
    end

    it 'returns element without changes' do
      expect([1, 2, 2].my_each_with_index { |n, _idx| n + 2 }).to eq([1, 2, 2])
    end

    it 'loops an entire array' do
      [1, 2, 0].my_each_with_index { |n, idx| empyt_arr[idx] = n + 2 }
      expect(empyt_arr).to eq([3, 4, 2])
    end

    it 'loops an entire hash' do
      { a: 1, b: 2, c: 0 }.my_each_with_index { |(k, v), idx| empyt_hash[k] = v + idx }
      expect(empyt_hash).to eq(a: 1, b: 3, c: 2)
    end
  end

  describe 'my_select' do
    it 'return enumerator if no block not given' do
      expect([1, 5, 2].my_select.class).to eq(Enumerator)
    end
    it 'selects array' do
      expect([1, 2, 4, 5].my_select { |n| n > 3 }).to eq([4, 5])
    end
    it 'return array of symbols :foo from array' do
      expect(%i[foo bar foo].my_select { |x| x == :foo }).to eql(%i[foo foo])
    end
  end

  describe 'my_all?' do
    it 'block not given, none of the elements false or nil' do
      expect([1, 5, 2].my_all?).to eq(true)
    end
    it 'block not given, one of the elements false or nil' do
      expect([1, nil, 2].my_all?).to eq(false)
    end
    it 'block not given, one of the elements false' do
      expect([1, false, 2].my_all?).to eq(false)
    end
    it 'block not given, one of the elements nil' do
      expect([1, 5, nil].my_all?).to eq(false)
    end
    it 'pattern other than a Class or Regex' do
      expect(%w[dog dog dog dog].my_all?('dog')).to eq(true)
    end
    it 'pattern other than a Class or Regex, false' do
      expect(%w[dog dog cat dog].my_all?('dog')).to eq(false)
    end
    it 'class given, all the elements from that class' do
      expect([1, 5, 8].my_all?(Integer)).to eq(true)
    end
    it 'class given, not all the elements from that class' do
      expect([1, 5, 8].my_all?(String)).to eq(false)
    end
    it 'all with array false' do
      expect([1, 2, 4, 5].my_all? { |n| n > 3 }).to eq(false)
    end
    it 'all with array true' do
      expect([1, 2, 4, 5].my_all? { |n| n >= 1 }).to eq(true)
    end
    it 'all with hash false' do
      expect({ a: 1, b: 2, c: 0 }.my_all? { |_k, v| v == 2 }).to eq(false)
    end
    it 'all with hash true' do
      expect({ a: 1, b: 2, c: 0 }.my_all? { |_k, v| v.is_a? Integer }).to eq(true)
    end
  end
end
