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

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

end