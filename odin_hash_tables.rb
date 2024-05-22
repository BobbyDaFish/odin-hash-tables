# frozen-string-literal: true

require 'pry-byebug'

# Hash map thing for odin project
class HashMap
  attr_accessor :buckets

  def initialize
    self.buckets = Array.new(16)
  end

  def hash(key)
    hash_code = 0
    prime_number = 31
    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
    hash_code %= buckets.size
  end

  def set(key, value)
    index = hash(key)
    return buckets[index] = [key, value] if buckets[index].nil?

    buckets[index][1] = value if buckets[index][0] == key
    collision(buckets[index], key, value) if buckets[index][0] != key
    raise IndexError if index.negative? || index >= @buckets.length

    grow_buckets(buckets)
  end

  def get(key)
    i = 0
    buckets.each do |arr|
      next if arr.nil?
      return arr[i + 1] if arr[i] == key

      unless arr[i + 2].nil?
        i += 2
        arr.get(key)
      end
    end
    nil
  end

  def has?(key)
    buckets.each do |arr|
      next if arr.nil?
      return true if arr[0] == key
    end
    false
  end

  def remove(key)
    index = hash(key)
    return nil if buckets[index].nil?

    buckets[index] = nil
  end

  def length
    i = 0
    buckets.each { |arr| i += 1 unless arr.nil? }
    i
  end

  def clear
    puts 'Clearing HashMap'
    self.buckets = Array.new(16)
  end

  def keys
    names = []
    buckets.each do |arr|
      next if arr.nil?
      return names << arr[0] if arr[2].nil?

      # need to get nested [0] values
    end
    names
  end

  def values
    data = []
    buckets.each do |arr|
      next if arr.nil?

      data << arr[1]
    end
    data
  end

  def entries
    data = []
    buckets.each do |arr|
      next if arr.nil?

      data << arr
    end
    return [] if data.nil?

    data
  end

  def grow_buckets(data)
    new_buckets = []
    return data if data.nil?

    if data.length > (data.size * 0.75)
      new_buckets << data
      new_buckets << Array.new(data.length)
      data = new_buckets.flatten!
    end
    data
  end

  def size
    i = 0
    buckets.each { i += 1 }
    i
  end

  def collision(data, key, value)
    return data[2] = [key, value] if data[2].nil?

    data[2] = collision(data[2], key, value)
    data
  end
end

map = HashMap.new
map.set('Carlos', 'first')
map.set('Carla', 'second')
p map.get('Thomas')
p map.has?('Carlos')
p map.has?('Thomas')
map.set('Thomas', 'third')
map.set('Tina', 'fourth')
map.set('Peter', 'fifth')
map.set('Sara', 'sixth')
p map.buckets
map.remove('Thomas')
p map.buckets
p map.length
p map.keys
p map.values
p map.entries.length
