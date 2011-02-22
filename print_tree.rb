# vim: ts=2 sw=2
# Visualize our tree

require 'graphviz'
require 'tree'

class Tree
	protected
		def mnodes(g)
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

	public
		def print_tree
			GraphViz.new(:G, :type => :digraph, :truecolor => true) {|g|
				mnodes g
				g.output :png => 'tree.png'
			}
		end
end
