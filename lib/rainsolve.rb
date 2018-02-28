#
#
#
#
class Rainsolver
  require_relative 'rainprint'
  require_relative 'rainfile'

  def initialize(from_char, to_char, from_num, to_num, permutations)
    @start_time = Time.now
    @prev_time = Time.now
    @passed_time = 0
    @prev_items_count = 0
    @from_char = from_char
    @to_char = to_char
    @from_num = from_num
    @to_num = to_num
    @permutations = permutations
    @chars = []
    @arr_items_per_second = []
    @file_name = 'output'
    @ips = 100_000
    @global_index = 0
  end

  def generate_chars_array(from_char, to_char, from_num, to_num)
    @chars = [
      *from_char.downcase..to_char.downcase,
      *from_char.upcase..to_char.upcase,
      *from_num.to_i..to_num.to_i
      ]
  end

  def calculate_total_permutations
    @total_permutations = @chars.size**@permutations
  end

  def calculate_avg_items_per_second
    @arr_items_per_second.inject(:+) / @arr_items_per_second.size
  end

  def prepare_data
    generate_chars_array(@from_char, @to_char, @from_num, @to_num)
    calculate_total_permutations
  end

  def seconds_to_time_format(total_seconds)
    if total_seconds > 0
      "%02d:%02d:%02d:%02d" % [
        total_seconds/86400,
        total_seconds/3600%24,
        total_seconds/60%60,
        total_seconds%60
      ]
    else
      "00:00:00:00"
    end
  end

  def calculate_time_passed
    @passed_time = Time.now - @start_time
  end

  def calculate_time_left
    calculate_time_passed
    left_time = (@total_permutations / calculate_avg_items_per_second) - @passed_time
    seconds_to_time_format(left_time)
  end

  def calculate_time_current_slice
    Time.now - @prev_time
  end

  def separate_comma(number)
    number.to_s.chars.to_a.reverse.each_slice(3).map(&:join).join(",").reverse
  end

  def print_stats
    # extract statistics if time is ~1sec

    items_current_round = @global_index - @prev_items_count
    @arr_items_per_second << items_current_round

    # calculate total time elapsed in seconds
    time_elapsed = (Time.now - @start_time)

    puts "#{time_elapsed}s : #{separate_comma(@global_index)} complete "\
      "(+#{separate_comma(items_current_round)} : "\
      "~#{separate_comma(calculate_avg_items_per_second)}/s) : "\
      "(#{separate_comma(@total_permutations - @global_index)} - #{calculate_time_left} left)"
    @prev_time = Time.now
    @prev_items_count = @global_index
  end

  def print_prologue
    puts "====> #{separate_comma(@total_permutations)} items will be generated"
  end

  def print_epilogue
    puts "===> Total: #{separate_comma(@global_index)} items - #{Time.now - @start_time}s"
  end

  #
  # repeated_permutation => Enumerator -> [[1, 1, 1], [1, 1, 2], [1, 1, 3]...
  # lazy =>
  # map(&:join) => ["111", "112", "113"...
  #
  def run
    @threads = []
    @mutex = Mutex.new

    @chars.repeated_permutation(@permutations).lazy.map(&:join).each_slice(@ips).with_index do |item, index|
      #puts "=========> outer_index: #{index} ---> @global_index: #{@global_index}"

      @threads << Thread.new do
        begin
          item.each do |vitem|
            # Rainfile.write_to_file
            @global_index += 1
          end
        rescue ThreadError => e
          puts "#{e}"
        end
        @mutex.synchronize { @global_index.to_i }
      end
      @threads.map(&:join)
      print_stats if calculate_time_current_slice >= 1
    end
  end

end
