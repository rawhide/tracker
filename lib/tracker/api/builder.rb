require 'json'
module Tracker # :nodoc:
  module Api # :nodoc:
    class Builder
      # @todo doc
      attr_accessor :no, :status, :date, :time, :place, :company, :description, :origin

      # @todo doc
      def initialize(no: nil, status: nil, date: nil, time: nil, place: nil, company: nil, description: nil, origin: nil)
        @no = no
        @status = status
        @date = date
        @time = time
        @place = place
        @company = company
        @description = description
        @origin = origin
      end

      # @todo doc
      def object_to_json
        object_to_hash.to_json
      end

      # @todo doc
      def object_to_hash
        #{no: no.to_s, status: status, date: date, time: time, place: place, company: company, description: description, origin: origin}
        data = {}
        self.instance_variables.each {|n| data[n.to_s.delete("@")] = self.instance_variable_get(n) }
        data
      end
    end
  end
end
