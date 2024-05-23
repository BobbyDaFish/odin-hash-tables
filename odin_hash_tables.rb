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

      i = 0
      return true if arr[i] == key || arr.flatten[i + 2] == key

      until arr.flatten[i].nil?
        return true if arr.flatten[i] == key

        i += 2
      end
    end
    false
  end

  def remove(key)
    return nil unless has?(key)

    buckets.each_with_index do |k, i|
      next if k.nil?

      if k == key
        buckets[index] = nil
        buckets[index + 1] = nil
        return key
      elsif k.flatten.any?(key)
        return deleter(key, k)
      else
        next
      end
    end
  end

  def deleter(key, data)
    if data[0] == key
      data[0] = nil
      data[1] = nil
      key
    else
      deleter(key, data[2])
    end
  end

  def length
    i = 0
    data = values

    data.each { i += 1 }
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

      i = 0
      until arr.flatten[i].nil?
        names << arr.flatten[i]
        i += 2
      end
    end
    names
  end

  def values
    data = []
    buckets.each do |arr|
      next if arr.nil?

      i = 1
      until arr.flatten[i].nil?
        data << arr.flatten[i]
        i += 2
      end
    end
    data
  end

  def entries
    data = []
    buckets.each do |arr|
      next if arr.nil?

      i = 0
      until arr.flatten[i].nil?
        data << arr.flatten[i..i + 1]
        i += 2
      end
    end
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

    collision(data[2], key, value)
  end
end

map = HashMap.new
map.set('Carlos', 'first')
map.set('Carla', 'second')

map.set('Thomas', 'third')
map.set('Tina', 'fourth')
map.set('Peter', 'fifth')
map.set('Sara', 'sixth')
map.set('Tim', 'seventh')
p map.buckets
map.set('John', 'eigth')
map.set('Lily', 'ninth')
map.set('Paul', 'tenth')
p map.remove('Thomas')
p map.has?('Paul')
p map.has?('Thomas')
p map.buckets
p map.length
p map.remove('Paul')
p map.keys
p map.values
p map.entries
