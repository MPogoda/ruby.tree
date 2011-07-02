# vim: tabstop=2 shiftwidth=2 softtabstop=2
=begin
=   For recall a red-black tree has the following properties:
=     1. All nodes are either BLACK or RED
=     2. Leafs are BLACK
=     3. A RED node has BLACK children only
=     4. Path from a node to any leafs has the same number of BLACK nodes.
=end
require 'template_tree'

class RedBlackTreeNode < TemplateTreeNode
  def red?
    @red
  end

  def black?
    not @red
  end

  def initialize(parent, key)
    super
    @red = true # we will make root black later, ok?
  end

  attr_writer :red # only writer, cause i have defined red? and black? (i think, it's really cool ^^ )
end

class RedBlackTree < TemplateTree
  def insert(key = nil)
    node, havent_inserted = super

    return node if havent_inserted

    # Fixup the modified tree by recoloring nodes and perfoming rotations (2 at most)
    # hence the red-black properties are preserved
    #
    # The node we've inserted is red if it's not root
    # So, we must perform some fixups only if its parent is red

    while ((parent = node.parent) and parent.red?) do
      grandpa = parent.parent #should always exists if we've assumed, that root is always BLACK

      lp = (grandpa.left == parent)
      uncle = if lp then  grandpa.right
              else        grandpa.left
              end

      if uncle and uncle.red? then # if uncle is red
        parent.red  = false
        uncle.red   = false
        grandpa.red = true
        node        = grandpa
      else
        lc = (parent.left == node)
        unless  lc == lp
        #     grandpa             grandpa                     grandpa
        #  parent   uncle   =>  node   uncle === rename === parent uncle
        # a   node  b   c   parent .. ......              node ........
          if lc then
            rotate_right parent
          else
            rotate_left  parent
          end
          node    = parent
          parent  = node.parent
        end
        #now our node and its parent are both right (or left) childs
        parent.red  = false
        grandpa.red = true
        if lc then
          rotate_right  grandpa
        else
          rotate_left   grandpa
        end
      end
    end
    @root.red = false
  end

  def remove(key = nil)
    raise "Empty key" unless key

    #search for node to delete
    node = lookup key
    return unless node

    parent  = node.parent
    right   = node.right
    left    = node.left

    @first  = node.next if @first.equal? node
    @last   = node.prev if @last.equal?  node

    _next = if not left then
              right
            elsif not right then
              left
            else
              right.first
            end

    if not parent  then             @root         = _next
    elsif parent.left == node then  parent.left   = _next
    else                            parent.right  = _next
    end

    if left and right then
      red,        _next.red   = _next.red?, node.red?
      _next.left, left.parent = left,       _next
      unless _next == right then
        parent, _next.parent = _next.parent, node.parent

        node          = _next.right
        parent.left   = node
        _next.right   = right
        right.parent  = _next
      else
        _next.parent  = parent
        parent        = _next
        node          = _next.right
      end
    else
      red   = node.red?
      node  = _next
    end

    node.parent = parent if node

    return if red

    if node and node.red? then
      node.red = false
      return
    end

    begin
      break if @root == node

      lc = (parent.left == node)
      sibling = if lc then  parent.right
                else        parent.left
                end
      if sibling.red? then
        sibling.red = false
        parent.red  = true
        sibling = if lc then
                    rotate_left  parent
                    parent.right
                  else
                    rotate_right parent
                    parent.left
                  end
      end
      if (lc and ((not sibling.right) or sibling.right.black?)) or
          (not lc and ((not sibling.left) or sibling.left.black?)) then
        sibling.red = true
        if (not lc and ((not sibling.right) or sibling.right.black?)) or
          (lc and ((not sibling.left) or sibling.left.black?)) then

          node    = parent
          parent  = node.parent
          next
        end

        sibling = if lc then
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
      parent.red  = false
      if lc then
        sibling.right.red = false
        rotate_left parent
      else
        sibling.left.red  = false
        rotate_right parent
      end
      node = @root
      break
    end while node.black?

    node.red = false if node
  end

  def initialize
    super
    @NODECLASS = ::RedBlackTreeNode
  end
end
