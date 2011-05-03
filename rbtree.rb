# vim: tabstop=2 shiftwidth=2 softtabstop=2
=begin
=   For recall a red-black tree has the following properties:
=     1. All nodes are either BLACK or RED
=     2. Leafs are BLACK
=     3. A RED node has BLACK children only
=     4. Path from a node to any leafs has the same number of BLACK nodes.
=end

class RedBlackTree
  class RedBlackTreeNode
    def red?
      @red
    end

    def black?
      not @red
    end

    def root?
      parent.nil?
    end

    #some internal iterators
    def first
      return @left.first unless @left.nil?
      self
    end

    def last
      return @right.last unless @right.nil?
      self
    end

    def next_parent
      return if @parent.nil?
      return self if self.equal? @parent.left
      @parent.next_parent
    end

    def next #public
      return @right.first unless @right.nil?

      next_parent
    end

    def prev_parent
      return if @parent.nil?
      return self if self.equal? @parent.right
      @parent.prev_parent
    end

    def prev #public
      return @left.last unless @left.nil?

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
      return if @right.nil?

      unless root? #then our node have parent
        if @parent.left.equal? self:  @parent.left = @right
        else                          @parent.right = @right
        end
      end

      @right.parent, @parent = @parent, @right

      @right = @right.left
      @right.parent = self unless @right.nil?

      @parent.left = self
      #return node x
    end

    def rotate_right!
=begin
=      x            a
=    a   b    =>   c x
=   c d e f      ... d b
=end
      return if @left.nil?

      unless root?
        if @parent.left.equal? self:  @parent.left = @left
        else                          @parent.right = @left
        end
      end

      @left.parent, @parent = @parent, @left

      @left = @left.right
      @left.parent = self unless @left.nil?

      @parent.right = self
    end

    def initialize(parent, data)
      @parent = parent
      @data = data.dup
      @left = nil
      @right = nil
      @red = (true and !parent.nil?) # root node can't be black, ok?
    end

    attr_writer :red # only writer, cause i have defined red? and black? (i think, it's really cool ^^ )
    attr_accessor :parent, :data, :left, :right

    def lookup key
=begin
      search for an item with @data[:key] == key end returns hash array
        :node --- a node if found, otherwise --- nil
        :parent -- parent of ^ node if found, otherwise the node, where we must add a new node
        :left --- (is :node a left child of :parent)
=end
      return :node => self, :parent => @parent, :left => (self == @parent.left) if key.eql? @data[:key]

      if key < @data[:key]
        return @left.lookup key unless @left.nil?
        return :node => nil, :parent => self, :left => true
      else
        return @right.lookup key unless @right.nil?
        return :node => nil, :parent => self, :left => false
      end
    end

  end

  def last #public
    @root.last unless @root.nil?
  end

  def first #public
    @root.first unless @root.nil?
  end

  def do_lookup key
    return :node => nil, :parent => nil if @root.nil?
    @root.lookup key
  end

  def rotate_left node
    return if node.nil? or node.right.nil?

    @root = node.right if node.root?

    node.rotate_left!
  end

  def rotate_right node
    return if node.nil? or node.left.nil?

    @root = node.left if node.root?

    node.rotate_right!
  end

  def lookup(data = nil) #public
    return if data.nil?
    result = do_lookup data[:key]
    return result[:node]
  end

  def insert(data = nil)#public
    return if data.nil?

    r = do_lookup data[:key]
    return r[:node] unless r[:node].nil?

    node = RedBlackTreeNode.new r[:parent], data
    if node.parent.nil?
      @root = node
      @first = node
      @last = node
    else
      if r[:left]
        node.parent.left = node
        @first = node if node.parent.equal? @first
      else
        node.parent.right = node
        @last = node if node.parent.equal? @last
      end
    end

    # Fixup the modified tree by recoloring nodes and perfoming rotations (2 at most)
    # hence the red-black properties are preserved
    #
    # The node we've inserted is red if it's not root
    # So, we must perform some fixups only if its parent is red
    while ((parent = node.parent) and parent.red?) do
      grandpa = parent.parent #should always exists if we've assumed, that root is always BLACK

      lp = (grandpa.left.equal? parent)
      uncle = if lp:  grandpa.right
              else    grandpa.left
              end

      unless uncle.nil? or uncle.black? # if uncle is red
        parent.red = false
        uncle.red = false
        grandpa.red = true
        node = grandpa
      else
        lc = (parent.left.equal? node)
        unless  lc.eql? lp
        #     grandpa             grandpa                     grandpa
        #  parent   uncle   =>  node   uncle === rename === parent uncle
        # a   node  b   c   parent .. ......              node ........
          if lc:  rotate_right parent
          else    rotate_left parent
          end
          node = parent
          parent = node.parent
        end
        #now our node and its parent are both right (or left) childs
        parent.red = false
        grandpa.red = true
        if lc:  rotate_right grandpa
        else    rotate_left grandpa
        end
      end
    end
    @root.red = false
  end

  def remove data=nil
    return if data.nil?

    # Search what we must delete
    node = lookup data
    return if node.nil?

    parent = node.parent
    left = node.left
    right = node.right

    @first = node.next if @first.equal? node
    @last  = node.prev if @last.equal? node
    _next = if    left.nil?:   right
            elsif right.nil?:  left
            else               right.first
            end

    if parent.nil?:                 @root = _next
    elsif parent.left.equal? node:  parent.left = _next
    else                            parent.right = _next
    end

    unless left.nil? or right.nil?
      red, _next.red = _next.red?, node.red?
      _next.left, left.parent = left, _next
      unless _next.equal? right
        parent, _next.parent = _next.parent, node.parent

        node = _next.right
        parent.left = node
        _next.right = right
        right.parent = _next
      else
        _next.parent = parent
        parent = _next
        node = _next.right
      end
    else
      red = node.red?
      node = _next;
    end

    node.parent = parent unless node.nil?

    return if red
    unless node.nil? or node.black?
      node.red = false
      return
    end

    begin
      break if @root.equal? node

      lc = (parent.left.equal? node)
      sibling = if lc:  parent.right
                else    parent.left
                end
      if sibling.red?
        sibling.red = false
        parent.red = true
        sibling = if lc
                    rotate_left  parent
                    parent.right
                  else
                    rotate_right parent
                    parent.left
                  end
      end
      if (lc and (sibling.right.nil? or sibling.right.black?)) or
          (not lc and (sibling.left.nil? or sibling.left.black?))
        if (sibling.right.nil? or sibling.right.black?) and (sibling.left.nil? or sibling.left.black?)
          sibling.red = true
          node = parent
          parent = node.parent
          next
        end
        sibling.red = true
        sibling = if lc
                    sibling.left.red = false
                    rotate_right sibling
                    parent.right
                  else
                    sibling.right.red = false
                    rotate_left sibling
                    parent.left
                  end
      end
      sibling.red = parent.red?
      parent.red = false
      if lc
        sibling.right.red = false
        rotate_left parent
      else
        sibling.left.red = false
        rotate_right parent
      end
      node = @root
      break
    end while node.black?

    node.red = false unless node.nil?
  end

  def initialize
    @root = nil
    @first = nil
    @last = nil
  end
end
