# module
# - https://codingpackets.com/blog/crystal-notes-modules/
# - https://crystal-lang.org/reference/1.10/syntax_and_semantics/modules.html

# module is similar to c-sharp `static class`
# so module can not be instantiated unlike class
# but it can be used as a mixin via `include` or `extend`
# - An `include` makes a type include methods defined in that module as instance methods
# - An `extend` makes a type include methods defined in that module as class methods (static method)
module LearnCrystal
  # module can be nested
  module Hi
    private HELLO = "hello"

    def self.say_hi
      puts HELLO
    end
  end

  Hi.say_hi
  puts ""

  # variable
  x = 10_u32
  p! typeof(x) # <-- UInt32
  s = "this is a string"
  p! typeof(s) # <-- String
  s = 1        # <-- variable shadowing
  p! typeof(s) # <-- Int32
  puts ""

  # truthy & falsy
  # `nil`, `false`, and `null pointers` are falsy
  # any other values are truthy
  if 0
    puts "truthy"
  end
  unless false
    puts "unless cond == if !(cond)"
  end
  puts ""

  # flow control statements don't make a new scope in crystal. this is inherited from ruby.
  # https://github.com/crystal-lang/crystal/issues/9588
  if 1 + 2 == 3
    a = 1
  else
    a = "hello"
  end
  puts typeof(a) # => Int32 | String
  puts ""

  # constant
  HELLO = "hello"

  # HELLO = "asd" # <-- error: already initialized constant LearnCrystal::HELLO

  # method
  def self.hi : Nil
    # ^^^^^ --> this means the method belongs to this module/class not the instance of it
    #           similar to csharp static method
    puts "hi"
  end

  hi # <-- this is a function call
  #        `()` is optional
  puts ""

  # module can be declared multiple times just like namespace
  module A
    HELLO = "hello"
    p! BYE
  end

  module A
    BYE = "bye"
  end

  puts ""

  def self.run(& : Int32 -> Int32)
    #          ^ --> this is a block
    #                https://crystal-lang.org/reference/1.9/syntax_and_semantics/blocks_and_procs.html
    puts yield 10
  end

  run do |number|
    number + 1
  end
  puts ""

  # string
  puts "string interpolation #{"hello".upcase}"
  puts %(s = \n "#{s}")             # <-- alternative delimiters
  puts "string interpolation \#{s}" # <-- escape string interpolation
  puts %q(s = \n #{s})              # <-- non-interpolating string literal
  puts %w(this is a string)         # <-- this returns an array of string (split by space)
  puts ""

  # array
  a = [2, 3] of Int32
  a << 4
  # ^^ --> appending a value
  int_arr = [1, *a, 5] of Int32
  #             ^^ --> splat expansion
  #                    https://crystal-lang.org/reference/1.10/syntax_and_semantics/literals/array.html#splat-expansion

  int_arr.each do |elem|
    puts elem
  end
  puts ""

  int_arr[...2].each do |elem|
    puts elem
  end
  puts ""

  head, *rest, tail = [1, 2, 3, 4, 5]
  puts "head: #{head}"
  puts "rest: #{rest}"
  puts "tail: #{tail}"
  puts ""

  # loop
  3.times do |i|
    p! i
  end
  puts ""

  res = (1..5).each do |i|
    if i == 2
      next # <-- continue
    end
    p! i
    break i if i == 5
    #     ^ ^^^^^^^^^
    #     │ └─> break condition
    #     └─> return this value after breaking
  end
  p! res
  puts ""

  res = (3..6).each_with_index do |val, i|
    p!({i, val})
  end
  puts ""

  # hash (key value pair)
  people = {
    "you" => "genius",
    "I'm" => "fool",
  }
  puts %(you are a #{people["you"]})
  puts %(I'm a #{people["I'm"]})

  people["I'm"] ||= "cool"
  #             ^^^ <-- set only when the key is not present
  puts %(||= I'm a #{people["I'm"]})

  people["I'm"] &&= "cool"
  #             ^^^ <-- set only when the key is present
  puts %(&&= I'm a #{people["I'm"]})
  puts ""

  # tuple
  tuple = {1, "안녕", 1.2}
  print "Enter a number (0 ~ 2): "
  i = gets
  if i # <-- check nil
    begin
      puts "tuple[#{i}] = #{tuple[i.to_i]}"
    rescue ex # <-- catch exception
      puts ex.message
    else # <-- when no exception is raised
      puts "no exception"
    end
  end
  puts ""

  # class
  class Human
    # https://crystal-lang.org/reference/1.10/syntax_and_semantics/methods_and_instance_variables.html#getters-and-setters
    getter age : Int32 = 10

    def initialize(@name : String) # <-- this is the constructor
    end

    def name=(value)
      puts "name changed to: #{value} from #{@name}"
      @name = value
    end

    def age=(value)
      puts "age changed to: #{value} from #{@age}"
      @age = value
    end
  end

  human = Human.new "John"
  human.age = 11
  human.name = "Tom"
  puts ""

  # multiple assignment
  a = 1
  b = 2
  puts "a = #{a}, b = #{b}"
  a, b = b, a
  puts "a = #{a}, b = #{b}"

  name, hi, wow = "doongjohn hello !!!".split(" ")
  puts name
  puts hi
  puts wow
  puts ""

  # case
  num = 10

  case num
  when 1
    puts "not match"
  when 10
    puts "match"
  end

  case num
  when .even?
    puts "match"
  when .odd?
    puts "not match"
  end

  case {10, 11}
  when {.even?, .odd?}
    puts "match"
  when {.even?, .even?}
    puts "not match"
  end

  case {100, "blahblah"}
  when {Int32, String}
    puts "match"
  when {Int32, Int32}
    puts "not match"
  end
  puts ""

  # enum
  enum SomeEnum
    HelloFriends
    Wow
    Cool
  end

  e = SomeEnum::HelloFriends
  p! e == SomeEnum::HelloFriends
  p! e.hello_friends?
  puts ""

  # shell command
  output = `echo foo`  # => "foo\n"
  puts output
  p! $?.success? # => true
  puts ""

  output = `ls`
  puts output
  p! $?.success? # => true
  puts ""
end

class Protocol
  module ClientInterface # <-- Interface via Module
    abstract def protocol_send_data(data)
    abstract def protocol_read_data(data)
  end

  include Protocol::ClientInterface

  def initialize(@client : ClientInterface)
    clients = [@client]
    clients[0].protocol_send_data "wow"
  end

  def protocol_send_data(data)
    @client.protocol_send_data data
  end

  def protocol_read_data(data)
    @client.protocol_read_data data
  end
end

class MyClient
  include Protocol::ClientInterface

  def protocol_send_data(data)
    puts "#{data} from MyClient"
  end

  def protocol_read_data(data)
    puts "#{data} from MyClient"
  end
end

p = Protocol.new(MyClient.new)
p.protocol_send_data "hello"
puts ""

# you can extend already existing class
# (`class` in crystal == `partial class` in c-sharp)
class MyClient
  def hi
    puts "MyClient.hi"
  end
end

m = MyClient.new
m.hi
puts ""

def hello(a, b, c)
  p! a, b, c
end

t = {a: 1, b: 2, c: 3}
hello **t

struct StaticArray
  def to_tuple
    {% begin %}
      {
        {% for index in 0...N %}
          self[{{index}}],
        {% end %}
      }
    {% end %}
  end
end

a = StaticArray[4, 5, 6]
#   ^^^^^^^^^^^ <-- StaticArray is a fixed size array that is allocated on the stack
hello *a.to_tuple

def print_slice(s : Slice)
  s.each do |elem|
    puts elem
  end
end

print_slice Slice[1, 2, 3]
#           ^^^^^ <-- Slice is a fixed size array that is allocated in the heap
