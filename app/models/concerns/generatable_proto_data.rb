# frozen_string_literal: true

require 'google/protobuf/well_known_types'

module GeneratableProtoData
  def gen_proto_data
    attributes.merge(
      "created_at" => proto_time_stamp(created_at),
      "updated_at" => proto_time_stamp(updated_at)
    )
  end

  private

  def proto_time_stamp(time)
    seconds = time.to_i
    nanos = time.nsec

    Google::Protobuf::Timestamp.new(seconds:, nanos:).to_time
  end
end
