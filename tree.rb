# vim: ts=2 sw=2

class Tree
	protected
		def Insert(key, data)
			return if key.nil? or data.nil?

			if @key.nil?
				@parent = nil
				@key = key
				@data = data
				return self
			end

			if key < @key
				if @left.nil?
					return @left = Tree.new(self, key, data)
				else
					return @left.Insert key, data
				end
			else
				if @right.nil?
					return @right = Tree.new(self, key, data)
				else
					return @right.Insert key, data
				end
			end
		end

		def Remove(key)
			return if key.nil?

			if key < @key
				return @left.Remove key unless @left.nil?
			elsif key > @key
				return @right.Remove key unless @right.nil?
			else
				x = nil
				if !@right.nil?
					x = @right
					x = x.left until x.left.nil?
				elsif !@left.nil?
					x = @left
					x = x.right until x.right.nil?
				end
				if x.nil?
					return @key = nil if @parent.nil?
					return @parent.left = nil if @parent.left == self
					return @parent.right = nil
				else
					@key = x.key
					@data = x.data
					return x.parent.left = nil if x.parent.left == x
					return x.parent.right = nil if x.parent.right == x
				end
			end
		end

		def Search(key)
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
