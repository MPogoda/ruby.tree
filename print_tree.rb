# vim: tabstop=2 shiftwidth=2 softtabstop=2
# Visualize our tree

require 'graphviz'
require 'rbtree'

class TemplateTreeNode
  def mnodes(g, nodes)
    root = g.add_node "#{@key.to_s}", :style => :filled, :fillcolor => :black, :fontcolor => :white, :penwidth => 0

    if self == nodes[:node] then
      root[:penwidth] = 2
      root[:color] = :chartreuse
    elsif self == nodes[:father] then
      root[:penwidth] = 2
      root[:color] = :blue
    elsif self == nodes[:uncle] then
      root[:penwidth] = 2
      root[:color] = :green
    elsif self == nodes[:grandpa] then
      root[:penwidth] = 2
      root[:color] = :cyan
    elsif self == nodes[:sibling] then
      root[:penwidth] = 2
      root[:color] = :darkgoldenrod
    elsif self == nodes[:cousin1] then
      root[:penwidth] = 2
      root[:color] = :deeppink
    elsif self == nodes[:cousin2] then
      root[:penwidth] = 2
      root[:color] = :gold
    end

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
  def print_tree(filename, nodes = {})
    GraphViz.new(:G, :type => :graph, :fontname => "Monaco", :dpi => 120) {|g|
      @root.mnodes g, nodes
      g.output :png => filename + ".png"
    }
  end
end

class RedBlackTreeNode < TemplateTreeNode
  def mnodes(g, nodes = {})
    root = super g, nodes
    root[:fillcolor] = :red if @red
    root
  end
end
