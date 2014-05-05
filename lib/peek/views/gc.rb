module Peek
  module Views
    class GC < View
      attr_reader :invokes
      attr_reader :invoke_time
      attr_reader :use_size
      attr_reader :total_size
      attr_reader :total_object
      attr_reader :gc_time

      def results
        parse_result

        {
          :invokes      => invokes,
          :invoke_time  => "%.2f" % invoke_time,
          :use_size     => use_size,
          :total_size   => total_size,
          :total_object => total_object,
          :gc_time      => "%.2f" % gc_time
        }
      end

      def parse_result
        results = ::GC::Profiler.result.split("\n")

        @invokes = 0
        @invoke_time = 0.0
        @use_size = 0
        @total_size = 0
        @total_object = 0
        @gc_time = 0.0

        return if results.empty?

        @invokes = results.first.scan(/\s+\d+(?:\.\d+)?/).first.strip

        results[2..-1].each do |line|
          _, invoke_time, use_size, total_size, total_object, gc_time = line.scan(/\s+\-?\d+(?:\.\d+)?/).collect(&:strip)

          @invoke_time  += invoke_time.to_f
          @use_size     += use_size.to_i
          @total_size   += total_size.to_i
          @total_object += total_object.to_i
          @gc_time      += gc_time.to_f
        end
      end

      private

      def setup_subscribers
        # Reset each counter when a new request starts
        before_request do |name, start, finish, id, payload|
          next if @profiler_already_enabled = ::GC::Profiler.enabled?
          
          ::GC::Profiler.enable
          ::GC::Profiler.clear
        end

        # Once the action is finished
        subscribe 'process_action.action_controller' do |name, start, finish, id, payload|
          next if @profiler_already_enabled
          
          ::GC::Profiler.disable
          ::GC::Profiler.clear
        end
      end
    end
  end
end
