Tas
===

Trees as strings

Community
---------

Meet us on IRC: [#lesscode](irc://chat.freenode.net/#lesscode) on
[freenode.net](http://freenode.net/).

Description
-----------

An instance of `Tas` represents a tree of similar objects, together
with a reducing function. The goal of the reducing function is to
reach a string representation of the tree, and that's why the
reduction triggering method is `to_s`. The `inspect` method is an
alias of `to_s`, with the consequence that the result of applying
the reducing function becomes the object's representation.

Usage
-----

Let's start with a trivial example:

```ruby
view = Tas.new do |params|
  params.to_s
end

view[:foo] = 1
view[:bar] = 2

assert_equal view.to_s, "{:foo=>1, :bar=>2}"
```

We can use other instances of `Tas` as leaves:

```ruby
foo = Tas.new do |params|
  params.to_s
end

bar = Tas.new do |params|
  params.to_s
end

baz = Tas.new do |params|
  params.to_s
end

foo[:a] = 1
foo[:b] = bar

bar[:c] = 2
bar[:d] = baz

baz[:e] = 3
baz[:f] = 4

assert_equal foo.to_s, "{:a=>1, :b=>{:c=>2, :d=>{:e=>3, :f=>4}}}"
```

To avoid the repeated definition of the reducing function, you can
create a new `Tas` instance from an existing one:

```ruby
foo = Tas.new do |params|
  params.to_s
end

bar = foo.new
baz = bar.new

foo[:bar] = bar
bar[:baz] = baz

assert_equal foo.to_s, "{:bar=>{:baz=>{}}}"
```

The following example renders some views with [Mote][mote]:

```ruby
require "tas"
require "mote"

# Create a viewer and define the rendering function
viewer = Tas.new do |params|
  mote(params[:src], params)
end

# Create two different components
page = viewer.new
view = viewer.new

# Each component has its own template
page[:src] = "views/layout.mote"
view[:src] = "views/index.mote"

# Both components have a title
page[:title] = "Hello"
view[:title] = "Welcome!"

# Insert one component into another
page[:content] = view

# Render all components
page.to_s
```

[mote]: https://github.com/soveran/mote

API
---

`params`: Hash with components.

`reduce`: Function for processing the `params` hash.

`new`: Create a new instance and propagate the `reduce` function.

`[](marker)`: Return the component at `params[marker]`.

`[]=(marker, component)`: Assign the component to `params[marker]`.

`fetch(marker)`: Return the element at `params[marker]` or raise
if the element is not present.

Errors
------

If no `reduce` function was defined, an attempt to call `to_s` will
raise the `Tas::ReduceMissing` exception.

An attempt to `fetch` an undefined marker will raise the
`Tas::MarkerMissing` exception.

Installation
------------

```
$ gem install tas
```
