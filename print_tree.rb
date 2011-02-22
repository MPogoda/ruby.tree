# vim: ts=2 sw=2

require 'graphviz'
require 'tree'

def Tree.mnodes(g) protected
	return if @key.nil?
	root = g.add_node "#{@key}"
	if !@left.nil?
		left = @left.mnodes g
		g.add_edge root, left, :color => :green
	end
	if !@right.nil?
		right = @right.mnodes g
		g.add_edge root, right, :color => :blue
	end
	return root
end

def Tree.print_tree
	GraphViz.new(:G, :type => :digraph, :truecolor => true) {|g|
		mnodes g
		g.output :png => 'tree.png'
	}
end
	
