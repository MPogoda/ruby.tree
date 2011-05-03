# vim: tabstop=2 shiftwidth=2 softtabstop=2
# Visualize our tree

require 'graphviz'
require 'rbtree'

class RedBlackTree
  class RedBlackTreeNode
    def mnodes g
      root = g.add_node "#{@data[:key]}"
      root[:color] = :red if @red
      left = if @left.nil?: g.add_node "nill#{@data[:key]}", :shape => :point
             else           @left.mnodes g
             end
      g.add_edge root, left

      right = if @right.nil?: g.add_node "nilr#{@data[:key]}", :shape => :point
              else            @right.mnodes g
              end
      g.add_edge root, right

      root
    end
  end

  def print_tree(filename)
    GraphViz.new(:G, :type => :graph, :truecolor => true) { |g|
      @root.mnodes g
      g.output :png => filename + ".png"
    }
  end
end
