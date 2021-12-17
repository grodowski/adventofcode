# frozen_string_literal: true

require "stringio"

Packet = Struct.new(
  :version,
  :type_id, # 4: literal value, 6: operator
  :length_type_id, # 0: 15 following bits represent the length in bits of subpackets
                   # 1: 11 following bits represent the number of subpackets
  :value, # groups of 4-bits are padded by leading bits (0: last group)
  :packets # subpackets determined by type_id and length_type_id
) do
  def sum_versions # part 1
    return version if packets.empty?

    version + packets.map(&:sum_versions).sum
  end

  def eval # part 2
    case type_id
    when 0
      eval_children.sum
    when 1
      eval_children.reduce(:*)
    when 2
      eval_children.min
    when 3
      eval_children.max
    when 4
      value
    when 5
      evaled = eval_children
      evaled[0] > evaled[1] ? 1 : 0
    when 6
      evaled = eval_children
      evaled[0] < evaled[1] ? 1 : 0
    when 7
      evaled = eval_children
      evaled[0] == evaled[1] ? 1 : 0
    end
  end

  def eval_children
    packets.map(&:eval)
  end
end

class PacketParser
  def initialize(binary_str)
    @binary = binary_str.is_a?(StringIO) ? binary_str : StringIO.new(binary_str)
  end

  def parse
    version = @binary.read(3).to_i(2)
    type_id = @binary.read(3).to_i(2)
    packets = []
    if type_id == 4
      value = read_literal
    else
      length_type_id = @binary.read(1).to_i
      case length_type_id
      when 0
        packets_bit_len = @binary.read(15).to_i(2) # next 15 bits bit-length
        current_pos = @binary.pos
        while @binary.pos - current_pos < packets_bit_len
          packets << self.class.new(@binary).parse
        end
      when 1
        packets_size = @binary.read(11).to_i(2) # next 11 bits is size
        packets_size.times { packets << PacketParser.new(@binary).parse }
      end
    end
    Packet.new(version, type_id, length_type_id, value, packets)
  end

  private

  def read_literal
    val = []
    loop do
      val_chunk = @binary.read(5)
      val << val_chunk[1..-1]
      break if val_chunk[0] == "0" # first zero msb - stop iteration
    end
    val.join.to_i(2)
  end
end

bits = File.read('input').chars.map { _1.to_i(16).to_s(2).rjust(4, "0") }.join
packet = PacketParser.new(bits).parse
puts "Answer 1: #{packet.sum_versions}"
puts "Answer 2: #{packet.eval}"
