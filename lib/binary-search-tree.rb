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
    return Node.new(value) if current_node.nil?

    current_node.left = self.insert(value, current_node.left) if current_node.data > value
    current_node.right = self.insert(value, current_node.right) if current_node.data < value

    current_node
  end


  def delete(value, current_node = @root)
    return current_node if current_node.nil?

    if value < current_node.data
      current_node.left = self.delete(value, current_node.left)
    elsif value > current_node.data
      current_node.right = self.delete(value, current_node.right)
    else
      return current_node.right if current_node.left.nil? 
      return current_node.left if current_node.right.nil?

      min_node = current_node.right
      min_node = min_node.left until min_node.left.nil?
      
      current_node.data = min_node.data
      current_node.right = self.delete(current_node.data, current_node.right)
    end

    current_node
  end


  def find(value, current_node = @root)
    return if current_node.nil? || current_node.data == value

    value < current_node.data ? find(value, current_node.left) : find(value, current_node.right)
  end


  def level_order
    queue = [@root]

      queue.each do |node|
        queue << node.left unless node.left.nil?
        queue << node.right unless node.right.nil?
      end

      return queue.each { |node| yield node } if block_given?
      return queue.map { |node| node.data }
  end
   

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

end

arr1 = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]



arr2 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]


tree1 = Tree.new(arr2)
tree1.pretty_print

def delete_these_from(values, tree)
  values.each { |v| tree.delete(v) }
  tree.pretty_print
end

def insert_these_to(values, tree)
  values.each { |value| tree.insert(value) }
  tree.pretty_print
end

arr3 = tree1.level_order { |n| n.data = n.data * 2}
puts arr3

insert_these_to([5, 4, 1, 12, 555], tree1)
