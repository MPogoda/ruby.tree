About
=====

A simple library for working with binary tree's.
It can be used for studying purposes.

Features
========

*	Two classes:
	*	Simple binary tree
	*	Red Black binary tree (self-balancing tree)
* Insert, Remove, Fetch
* Print tree structure into PNG-file

Requirements
============

just Ruby. It works on version 1.8.7
for printing the tree, run `gem install ruby-graphviz`

Usage
=====

Simply include tree.rb for working only with simple binary trees,
redblacktree.rb for working also with red black trees and print_tree.rb for printing them.

Note that print_tree.rb includes redblacktree.rb, and redblacktree.rb includes tree.rb.

Example
=======
	require 'tree'

	r = Tree.new
	r.insert(123, "asd").insert(4123, "dsa").print_tree "graph"
	system("feh graph.png")

