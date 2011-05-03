About
=====

A simple library for working with binary tree's.
It can be used for studying purposes.

Features
========

*   Currently one class:
    *   Red-Black binary tree (self-balancing tree)
* Insert, Remove, Fetch
* Print tree structure into PNG-file

Requirements
============

Just Ruby. It works on version 1.8.7
For printing the tree, run `sudo gem install ruby-graphviz`

Usage
=====

Simply include rbtree.rb for working with red-black trees and print_tree.rb for printing them.
The data you will try to insert to tree or remove from there must be Hash object, with :key.
data[:key] is used for sorting purposes.
Equal keys aren't supported: when you try to insert a data with :key, that is already in rbtree,
the node with that key will returned to you.
Note that print_tree.rb includes rbree.rb

Example
=======
    require 'print_tree'
    tree = RedBlackTree.new

    data = Hash.new
    # simply add elements from 1 to 100000 to tree
    1.upto(100000) {|x|
        data[:key] = x
        tree.insert data
    }

    # remove every third element from 1 to 100000
    1.step(100000, 3) { |x|
        data[:key] = x
        tree.remove data
    }

    # print the tree in graph.png
    tree.print_tree "graph"

