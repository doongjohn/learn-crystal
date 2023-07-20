# modules: https://codingpackets.com/blog/crystal-notes-modules/

module Learn::Crystal # <-- module is similar to csharp `static class`
                      #     but also can be used as a mixin via `include`
  # Variable
  x = 10_u32
  s = "this is string"
  puts typeof(s) # <-- String
  s = 1 # <-- variable shadowing
  puts typeof(s) # <-- Int32
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

  # Flow control statements don't make a new scope in Crystal. This is inherited from Ruby.
  # https://github.com/crystal-lang/crystal/issues/9588
  if 1 + 2 == 3
    a = 1
  else
    a = "hello"
  end
  puts typeof(a) # => Int32 | String
  puts ""

  # Constant
  HELLO = "hello"
  # HELLO = "asd" # <-- error: already initialized constant Learn::Crystal::HELLO

  # Method
  def self.hi : Nil
    # ^^^^^ --> this means the method belongs to this module/class not the instance of it
    #           similar to csharp static method
    puts "hi"
  end

  hi # <-- this is a function call
     #     `()` is optional
  puts ""

  # Module
  module Hi
    # module can be nested
    HELLO = "hello"

    def self.say_hi
      puts "hi"
    end
  end

  p! Hi::HELLO
  p! Hi.say_hi
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

  # String
  puts "s = #{s}"
  puts %q(s = \n #{s})
  puts %(s = \n "#{s}")
  puts %w(this is string) # <-- split string by space
  puts ""

  # Array
  a = [2, 3] of UInt32
  int_arr = [1, *a, 4] of UInt32
  int_arr << 5
  puts typeof(int_arr)
  puts ""

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

  # Loop
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
    #     └─> break with value
  end
  p! res
  puts ""

  res = (3..6).each_with_index do |val, i|
    p! ({i, val})
  end
  puts ""

  # Hash (key value pair)
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

  # Tuple
  print "Enter a number: "
  tuple = {1, "안녕", nil}
  i = gets
  if i # <-- check nil
    begin
      i = i.to_i
    rescue ex # <-- catch exception
      puts ex.message
    else # <-- when no exception is raised
      puts tuple[i]
    end
  end
  puts ""

  # Class
  class Human
    # property name : String
    getter age : Int32 = 10

    def initialize(@name : String) # <-- this is the constructor
    end

    def name=(value)
      puts "name changed to: #{value} from #{@name}"
      @name = value
    end

    def age=(value)
      @age = value
      puts "age changed to: #{value} from #{@age}"
    end
  end

  human = Human.new "John"
  human.age = 11
  human.name = "Tom"
  puts ""

  # Multiple assignment
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

  # Case
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

  # Enum
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
  p! `echo foo`  # => "foo\n"
  p! $?.success? # => true

  p! `ls`
  p! $?.success? # => true
end

# Interface via Module
class Protocol
  module ClientInterface
    abstract def protocol_send_data(data : Bytes)
    abstract def protocol_read_data(data : Bytes)
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
