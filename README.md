About
=====

A simple library for working with binary tree's.
    It can be used for studying purposes.

Features
========

*   Currently one class:
    *   Red-Black binary tree (self-balancing tree)
* Insert, Remove, Fetch
* Support for visualizing tree using GraphViz[http://graphviz.org]

Requirements
============

Just Ruby. It works fine on version 1.8.7.
    For printing the tree, you have to install graphviz and ruby-graphviz gem.

Usage
=====

Simply include rbtree.rb for working with red-black trees and print_tree.rb for printing them.
    The key you will try to insert to tree or remove from there must be comparable object.
    Equal keys aren't supported: when you try to insert a duplicate key, the node with that key will be returned to you.

Example
=======
    require 'print_tree'
    tree = RedBlackTree.new

    # simply add elements from 1 to 100000 to tree
    1.upto(100000) {|x| tree.insert x }

    # remove every third element from 1 to 100000
    1.step(100000, 3) { |x| tree.remove x }

    # and print tree to a file tree.png
    tree.print_tree "tree"
