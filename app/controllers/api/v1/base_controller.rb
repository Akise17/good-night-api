# frozen_string_literal: true

class Api::V1::BaseController < ApplicationController
  include ApiResponseHandler

  before_action :set_resources, only: %i[index]
  before_action :set_resource, only: %i[show update destroy]
  before_action :set_default_pagination, only: %i[index]
  around_action :rollback_on_create, only: :create

  def index
    # TODO: Implement Filtering, Sorting, Searching

    render_response
  end

  def update
    raise 'Implement update action in child controller'
  end

  def create
    raise 'Implement update action in child controller'
  end

  def show
    render_response
  end

  def destroy
    @resource.destroy!
    # 204 No Content when success delete
  end

  private

  def set_resources
    model_class = service_name.constantize
    associations = model_class.reflect_on_all_associations.reject do |association|
      association.options[:polymorphic]
    end.map(&:name)

    @resources = model_class.includes(associations)
  end

  def set_resource
    @resource = service_name.constantize.find(params[:id])
  end

  def service_name
    controller_name.camelize.singularize
  end

  def set_default_pagination
    params[:page] ||= 1
    params[:per_page] ||= 10
  end

  def render_response(data = nil)
    data ||= @resource || @resources

    render_json(
      data: data,
      message: "#{action_name.capitalize.humanize} #{service_name}"
    )
  end

  def rollback_on_create
    ActiveRecord::Base.transaction do
      yield
    end
  end
end
