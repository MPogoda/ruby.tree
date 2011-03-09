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

		def Do_Remove
			foo = nil	# Node we'll delete
			lc = false # Is our node left child, used for deleting node without children
			bar = nil # Child of foo

			# If our node doesn't have both children
			if @left.nil? or @right.nil?
				# Then we'll delete this node
				foo = self
			else
				# Find successor of our node
				# (node in right subtree without left child)
				foo = @right
				foo = foo.left until foo.left.nil?
			end

			# Chose the child of foo
			if !foo.left.nil?
				bar = foo.left
			else
				bar = foo.right
			end

			bar.parent = foo.parent unless bar.nil?
			if foo.parent.nil? # If deleting root
				if bar.nil? # If there is no children
					@key = nil
				else
					copy bar
				end
			else
				if foo == foo.parent.left
					foo.parent.left = bar
					lc = true
				else
					foo.parent.right = bar
				end
			end

			# Copy the data
			if foo != self
				@data = foo.data
				@key = foo.key
			end

			# If we've deleted black node
			if !foo.red?
				# Hack, if we've deleted node without children
				if bar.nil?
					bar = foo
					bar.data = nil # Ouch
				end

				until bar.nil? or bar.parent.nil? or bar.red?
					lc = (bar == bar.parent.left) unless bar.data.nil?

					# Choose brother
					if lc
						foo = bar.parent.right
					else
						foo = bar.parent.left
					end
					
					if !foo.nil? # If we have brother
						
						if foo.red?
							foo.red = false
							bar.parent.red = true

							if lc
								bar.parent.rotate_left
								foo = bar.parent.right
							else
								bar.parent.rotate_right
								foo = bar.parent.left
							end

						end #foo.red?

						if (foo.left.nil? or !foo.left.red?) and (foo.right.nil? or !foo.right.red?)
							foo.red = true
							bar = bar.parent
						else

							if lc and (foo.right.nil? or !foo.right.red?)
								foo.left.red = false unless foo.left.nil?
								foo.red = true
								foo.rotate_right
								foo = bar.parent.right
							end

							if !lc and (foo.left.nil? or !foo.left.red?)
								foo.right.red = false unless foo.right.nil?
								foo.red = true
								foo.rotate_left
								foo = bar.parent.left
							end

							foo.red = bar.parent.red?
							bar.parent.red = false

							if lc
								foo.right.red = false unless foo.right.nil?
								bar.parent.rotate_left
							else
								foo.left.red = false unless foo.left.nil?
								bar.parent.rotate_right
							end

							bar = bar.parent until bar.parent.nil?
						end
					end #!foo.nil?
				end # until 
				bar.red = false unless bar.nil?
			end #!foo.red?

			foo.red = false if foo.parent.nil?
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
end
