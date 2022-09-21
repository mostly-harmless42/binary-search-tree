require_relative 'node'

class Tree
  attr_accessor :root
  
  def initialize(arr)
    arr = arr.sort.uniq
    @root = build_tree(arr)
  end


  def build_tree(arr)
    return if arr.empty?
    return Node.new(arr[0]) if arr.size == 1

    mid = arr.size / 2

    root = Node.new(arr[mid])
    root.left = self.build_tree(arr[0, mid])
    root.right = self.build_tree(arr[mid+1, mid])

    root
  end


  def insert(value, current_node = @root)
    return Node.new(value) unless current_node

    current_node.left = self.insert(value, current_node.left) if current_node.data > value
    current_node.right = self.insert(value, current_node.right) if current_node.data < value

    current_node
  end


  def delete(value, current_node = @root)
    return unless current_node

      current_node.left = self.delete(value, current_node.left)  if value < current_node.data
      current_node.right = self.delete(value, current_node.right) if value > current_node.data
      
    if value == current_node.data
      return current_node.right unless current_node.left
      return current_node.left unless current_node.right

      min_node = current_node.right
      min_node = min_node.left while min_node.left

      current_node.data = min_node.data
      current_node.right = self.delete(current_node.data, current_node.right)
    end

    current_node
  end


  def find(value, current_node = @root)
    return current_node if current_node.nil? or current_node.data == value

    value < current_node.data ? find(value, current_node.left) : find(value, current_node.right)
  end


  def level_order()
    arr = [@root]

      arr.each do |node|
        arr << node.left if node.left
        arr << node.right if node.right
      end

      return arr.each { |node| yield node } if block_given?
      return arr.map { |node| node.data }
  end


  def in_order

    def recursion(current_node = @root, arr = [])
      if current_node
        recursion(current_node.left, arr) 
        arr << current_node
        recursion(current_node.right, arr)
     end
     arr
    end

    return recursion.each { |node| yield node } if block_given?
    return recursion.map { |node| node.data }
  end


  def pre_order

    def recursion(current_node = @root, arr = [])
      if current_node
        arr << current_node
        recursion(current_node.left, arr) 
        recursion(current_node.right, arr)
     end
     arr
    end

    return recursion.each { |node| yield node } if block_given?
    return recursion.map { |node| node.data }
  end


  def post_order

    def recursion(current_node = @root, arr = [])
      if current_node
        arr << current_node
        recursion(current_node.left, arr) 
        recursion(current_node.right, arr)
     end
     arr
    end

    return recursion.each { |node| yield node } if block_given?
    return recursion.map { |node| node.data }
  end

  
  def height(node = @root)
    return -1 unless node
    return [height(node.left), height(node.right)].max + 1
  end


  def depth(node)
    return height(@root) - height(node)
  end


  def balanced?(current_node = @root)
    return true unless current_node
    return false if (height(current_node.left) - height(current_node.right)).abs > 1 
    return false unless balanced?(current_node.left) and balanced?(current_node.right)
    true
  end


  def rebalance
    @root = build_tree(in_order)
  end


  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
  
end
