module Peek
  module Views
    class GC < View
      def results
        {
          :invokes => 15,
          :invoke_time => 0.012,
          :use_size => 159240,
          :total_size => 212940,
          :total_object => 10647,
          :gc_time => 0.00000000000001530000
        }
      end

      private

      def setup_subscribers
        # Reset each counter when a new request starts
        before_request do |name, start, finish, id, payload|
          ::GC::Profiler.enable
        end

        subscribe 'process_action.action_controller' do |name, start, finish, id, payload|
          ::GC::Profiler.disable
          ::GC::Profiler.clear
        end
      end
    end
  end
end
