# vim: tabstop=2 shiftwidth=2 softtabstop=2
# Visualize our tree

require 'graphviz'
require 'rbtree'

class TemplateTreeNode
  def mnodes(g)
    root = g.add_node "#{@key.to_s}", :style => :filled, :fillcolor => :black, :fontcolor => :white, :penwidth => 0

    left  = if @left then  @left.mnodes g, nodes
            else           g.add_node "nill#{@key.to_s}", :shape => :point
            end
    g.add_edge root, left, :decorate => true

    right = if @right then @right.mnodes g, nodes
            else           g.add_node "nilr#{@key.to_s}", :shape => :point
            end
    g.add_edge root, right, :decorate => true

    root
  end
end

class TemplateTree
  def print_tree(filename)
    GraphViz.new(:G, :type => :graph, :fontname => "Monaco", :dpi => 120) {|g|
      @root.mnodes g
      g.output :png => filename + ".png"
    }
  end
end

class RedBlackTreeNode < TemplateTreeNode
  def mnodes(g)
    root = super
    root[:fillcolor] = :red if @red
    root
  end
end
