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
end
