# vim: tabstop=2 shiftwidth=2 softtabstop=2

class TemplateTreeNode
  def first
    return @left.first if @left
    self
  end

  def last
    return @right.last if @right
    self
  end

  def next_parent
    return unless @parent
    return @parent if self == @parent.left
    @parent.next_parent
  end

  def prev_parent
    return unless @parent
    return @parent if self == @parent.right
    @parent.prev_parent
  end

  def next
    return @right.first if @right

    next_parent
  end

  def prev
    return @left.last if @left

    prev_parent
  end

  #Internal rotate operations
  #They preserve the binary search tree property (if keys are unique)
  def rotate_left!
=begin
=     x           b
=   a   b   =>  x  f
=  c d e f     a e ...
=end
    if @parent then #then our node have parent
      if @parent.left == self then  @parent.left = @right
      else                          @parent.right = @right
      end
    end

    @right.parent, @parent = @parent, @right

    @right = @right.left
    @right.parent = self if @right

    @parent.left = self
    #returns node x
  end

  def rotate_right!
=begin
=      x            a
=    a   b    =>   c x
=   c d e f      ... d b
=end
    if @parent then
      if @parent.left == self then  @parent.left = @left
      else                          @parent.right = @left
      end
    end

    @left.parent, @parent = @parent, @left

    @left = @left.right
    @left.parent = self if @left

    @parent.right = self
  end

  def initialize(parent, key)
    @parent = parent
    @key = begin
             key.dup
           rescue TypeError #if key doesn't have method #dup
             key
           end
    @left = nil
    @right = nil
  end

  def lookup(key)
=begin
      search for an item with @key == key end returns hash array
        :node --- a node if found, otherwise --- nil
        :parent -- parent of ^ node if found, otherwise the node, where we must add a new node
        :left --- (is :node a left child of :parent)
=end
    return :node => self, :parent => @parent, :left => (parent and (self == @parent.left)) if key == @key

    if key < @key then
      if @left then
        @left.lookup key, tree, prefix, log
      else
        return :node => nil, :parent => self, :left => true
      end
    else
      if @right then
        @right.lookup key, tree, prefix, log
      else
        return :node => nil, :parent => self, :left => false
      end
    end
  end

  attr_accessor :parent, :key, :left, :right

  protected :next_parent, :prev_parent
end

class TemplateTree
  def empty?
    not @root
  end

  def last
    @root.last if @root
  end

  def first
    @root.first if @root
  end

  def each
    return unless @root
    node = @first
    loop do
      yield node
      break if node == @last
      node = node.next
    end
  end

  def do_lookup(key)
    return :node => nil, :parent => nil unless @root
    @root.lookup key
  end

  def rotate_left(node)
    return unless node and node.right

    @root = node.right if node == @root

    node.rotate_left!
  end

  def rotate_right(node)
    return unless node and node.left

    @root = node.left if node == @root

    node.rotate_right!
  end

  def lookup(key = nil)
    raise "Empty key" unless key

    do_lookup(key)[:node]
  end

  def insert(key = nil)
    raise "Empty key" unless key

    r = do_lookup key
    return r[:node], true if r[:node]

    node = @NODECLASS.new r[:parent], key
    unless node.parent then
      @root   = node
      @first  = node
      @last   = node

    else
      if r[:left] then
        node.parent.left = node
        @first = node if node.parent == @first

      else
        node.parent.right = node
        @last = node  if node.parent == @last

      end
    end

    return node, false
  end

  def initialize
    @root       = nil
    @first      = nil
    @last       = nil
    @NODECLASS  = TemplateTreeNode
  end
  private :do_lookup
  protected :rotate_left, :rotate_right
end
