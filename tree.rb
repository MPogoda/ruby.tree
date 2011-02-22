# vim: ts=2 sw=2

class Tree
	protected

		# Insert new node
		def Insert(key, data)
			# If we run it without parameters
			return if key.nil? or data.nil?

			# If we are at root
			if @key.nil?
				@key = key
				@data = data
				return self
			end

			if key < @key
				# Go to left branch
				if @left.nil?
					# If we've found where to insert
					return @left = Tree.new(self, key, data)
				else
					return @left.Insert key, data
				end
			else
				# Go to right branch
				if @right.nil?
					return @right = Tree.new(self, key, data)
				else
					return @right.Insert key, data
				end
			end
		end

		# Remove node
		def Remove(key)
			return if key.nil?

			if key < @key
				return @left.Remove key unless @left.nil?
			elsif key > @key
				return @right.Remove key unless @right.nil?
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
					return @key = nil if @parent.nil?
					# If our node is left child
					return @parent.left = nil if @parent.left == self
					return @parent.right = nil
				else
					# Copy data from next (or previous) node
					@key = x.key
					@data = x.data
					# Delete node x
					return x.parent.left = nil if x.parent.left == x
					return x.parent.right = nil if x.parent.right == x
				end
			end
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

		attr_accessor :left, :right, :key, :data
		attr_reader :parent
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
