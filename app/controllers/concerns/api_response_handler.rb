# frozen_string_literal: true

module ApiResponseHandler
  extend ActiveSupport::Concern

  def render_json(data: {}, serializer: '', message: '', code: :ok, extra: {}, use_extra: false)
    json = {}
    json[:meta] = { message: }

    if params[:page].present? && params[:per_page].present?
      json[:meta][:page] = params[:page].to_i
      json[:meta][:per_page] = params[:per_page].to_i
      total_pages = ((data&.count || 0) / params[:per_page].to_f).ceil
      json[:meta][:total_page] = total_pages.positive? ? total_pages : 1
      json[:meta][:total_data] = data&.count || 0
    end

    begin
      json[:data] = use_extra ? extra : serialize(data, serializer).as_json
    rescue NoMethodError
      json[:meta][:render_method] = 'general'
      json[:data] = data.as_json
    end

    render json:, status: code
  end

  private

  def serialize(data, serializer)
    serializer_class = "#{serializer}Serializer".safe_constantize
    raise "#{serializer}Serializer not implemented yet" if serializer_class.nil?

    if params[:page].present? && params[:per_page].present?
      data = data.paginate(page: params[:page], per_page: params[:per_page])
      return ActiveModelSerializers::SerializableResource.new(data, each_serializer: serializer_class)
    end

    return ActiveModelSerializers::SerializableResource.new(data, each_serializer: serializer_class) if data.is_a?(ActiveRecord::Relation)

    ActiveModelSerializers::SerializableResource.new(data, serializer: serializer_class)
  end
end
