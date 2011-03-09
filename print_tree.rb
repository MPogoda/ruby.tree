# vim: ts=2 sw=2
# Visualize our tree

require 'graphviz'
require 'redblacktree'

class Tree
	protected
		def mnodes(g)
			return if @key.nil?
			root = g.add_node "#{@key}"
			if !@left.nil?
				left = @left.mnodes g
			else
				left = g.add_node "nill#{@key}", :shape => :point
			end
			g.add_edge root, left
			if !@right.nil?
				right = @right.mnodes g
			else
				right = g.add_node "nilr#{@key}", :shape => :point
			end
			g.add_edge root, right
			return root
		end

	public
		def print_tree(filename)
			GraphViz.new(:G, :type => :graph, :truecolor => true) {|g|
				mnodes g
				g.output :png => filename+".png"
			}
		end
end

class RedBlackTree < Tree
	protected
		def mnodes(g)
			root = super g
			root[:color] = :red if @red
			return root
		end
end
