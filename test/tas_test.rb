require_relative "../lib/tas"

test "basic" do
  viewer = Tas.new do |params|
    sprintf(params[:format] % params)
  end

  foo = viewer.new
  bar = viewer.new

  foo[:format] = "%{hoge} %{piyo} and %{fuga}"
  bar[:format] = "%{hoge}!"

  foo[:hoge] = "right"
  foo[:piyo] = "here"
  foo[:fuga] = bar

  bar[:hoge] = "now"

  assert_equal foo.to_s, "right here and now!"
end

test "errors" do
  foo = Tas.new

  assert_raise(Tas::ReduceMissing) do
    foo.to_s
  end

  assert_raise(Tas::MarkerMissing) do
    foo.fetch(:src)
  end

  foo.reduce = -> (params) {
    params.to_s
  }

  assert_equal "{}", foo.to_s

  foo[:src] = "foo"

  assert_equal "foo", foo.fetch(:src)
end

test "update" do
  foo = Tas.new

  foo.update(hage: 1, piyo: 2)

  assert_equal 1, foo[:hage]
  assert_equal 2, foo[:piyo]
end
