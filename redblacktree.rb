# vim: ts=2 sw=2

require 'tree'

class RedBlackTree < Tree
	protected
		def copydata(node)
			super node
			@red = node.red?
		end

		def Insert(key, data)
			super key, data

			# Find the node we've inserted
			if !@left.nil? and @left.key == key
				x = @left
			elsif @right.nil?
				# If we've inserted the root
				return self
			else
				x = @right
			end

			# While our RedBlackTree is broken red-black-tree
			while !x.parent.nil? and x.parent.red? and x.red? do
				if !x.parent.parent.nil?
					# If uncle of our node is also red
					if !x.parent.parent.right.nil? and !x.parent.parent.left.nil? and x.parent.parent.right.red? and x.parent.parent.left.red?
						x = x.parent.parent
						x.left.red = false
						x.right.red = false
						x.red = true
						next
					# If uncle of our node is black
					elsif x.parent.parent.right.nil? or x.parent.parent.left.nil? or !x.parent.parent.right.red? or !x.parent.parent.left.red?
						# Is our node's parent left child
						lp = (x.parent.parent.left == x.parent)
						# Is our node left child
						lc = (x.parent.left == x)

						x = x.parent
						
						if (lc != lp)
							if lc
								x.rotate_right
							else
								x.rotate_left
							end
						end

						x.parent.red = true
						x.red = false

						x = x.parent

						if lp
							x.rotate_right
						else
							x.rotate_left
						end
					end
				else
					x.parent.red = false
				end
			end
			# Root of the tree must be black
			x.red = false if x.parent.nil?

			return self if @parent.nil?
		end

		def Remove(key)
			return if key.nil?
			super key


			return self if @parent.nil?
		end

		attr_writer :red, :parent

		def red?
			return @red
		end

	public

		def initialize (parent = nil, key = nil, data=nil)
			super parent, key, data
			@red = (parent != nil)
		end

		def insert(key, data)
			return Insert key, data
		end

end
