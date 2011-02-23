# vim: ts=2 sw=2

class Tree
	protected

		def copydata(node)
			@key = node.key
			@data = node.data
		end

		def copy(node)
			@left = node.left
			@right = node.right
			copydata node
		end

		def rotate_left
			return if @right.nil?

			me = self.class.new
			me.copy self
			x = self.class.new
			x.copy @right

			@left.parent = me unless @left.nil?
			x.left.parent = me unless x.left.nil?
			me.right = @right.left
			x.left = me

			copy x

			@right.parent = self unless @right.nil?
			@left.parent = self unless @left.nil?
		end

		def rotate_right
			return if @left.nil?

			me = self.class.new
			me.copy self
			x = self.class.new
			x.copy @left

			@right.parent = me unless @right.nil?
			x.right.parent = me unless x.right.nil?
			me.left = @left.right
			x.right = me

			copy x

			@right.parent = self unless @right.nil?
			@left.parent = self unless @left.nil?
		end

		# Insert new node
		def Insert(key, data)
			# If we run it without parameters
			return if key.nil? or data.nil?

			# If we are at root
			if @key.nil?
				@key = key
				@data = data
			elsif key < @key
				# Go to left branch
				if @left.nil?
					# If we've found where to insert
					@left = self.class.new(self, key, data)
				else
					@left.Insert key, data
				end
			else
				# Go to right branch
				if @right.nil?
					@right = self.class.new(self, key, data)
				else
					@right.Insert key, data
				end
			end

			return self if @parent.nil?
		end

		# Remove node
		def Remove(key)
			return if key.nil?

			if key < @key
				@left.Remove key unless @left.nil?
			elsif key > @key
				@right.Remove key unless @right.nil?
			else
				x = nil
				# We must found the node next to which we wanna delete
				# or previous, if there's no next
				if !@right.nil?
					x = @right
					x = x.left until x.left.nil?
				elsif !@left.nil?
					x = @left
					x = x.right until x.right.nil?
				end
				if x.nil?
				# If our node hasn't children
					# If our node is root
					if @parent.nil?
						@key = nil
					elsif @parent.left == self
						# If our node is left child
						@parent.left = nil
					else
						@parent.right = nil
					end
				else
					# Copy data from next (or previous) node
					@key = x.key
					@data = x.data
					# Delete node x
					if x.parent.left == x
						x.parent.left = nil
					else
						x.parent.right = nil
					end
				end
			end

			return self if @parent.nil?
		end

		def Search(key)
			# Find and returns node
			return if key.nil?

			if key < @key
				return @left.Search key unless @left.nil?
			elsif key > @key
				return @right.Search key unless @right.nil?
			else
				return self
			end
		end

		attr_accessor :left, :right, :key, :data, :parent
	public

		def initialize(parent = nil, key = nil, data = nil)
			@parent = parent
			@key = key
			@data = data
			@left = nil
			@right = nil
		end

		def insert(key, data)
			return Insert key, data
		end

		def remove(key)
			return Remove key
		end
	
		def fetch(key)
			x = Search key
			return x.data unless x.nil?
		end
end
