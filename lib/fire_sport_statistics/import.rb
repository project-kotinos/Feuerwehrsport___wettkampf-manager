module FireSportStatistics
  class Import

    protected

    def fetch(key)
      print_percent(key, 1, 0) unless @quiet
      collection = API::Get.fetch(key)
      count = collection.count
      collection.each_with_index do |entry, index|
        yield(entry)
        print_percent(key, count, index) unless @quiet
      end
      print_percent(key, 1, 1) unless @quiet
      puts "" unless @quiet
    end

    def print_percent(key, count, index)
      print "#{key}: #{(index.to_f/count.to_f*100).round}%\r"
      STDOUT.flush
    end
  end
end