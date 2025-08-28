# frozen_string_literal: true

module ApiExceptionHandler
  extend ActiveSupport::Concern

  included do
    EXCEPTIONS = {
      'NotFound' => { status: :not_found, code: 'NOT_FOUND',
                      message: I18n.t('exceptions.not_found') },
      'BadRequest' => { status: :bad_request, code: 'BAD_REQUEST',
                        message: I18n.t('exceptions.bad_request') },
      'Unauthorized' => { status: :unauthorized, code: 'UNAUTHORIZED',
                          message: I18n.t('exceptions.unauthorized') },
      'ResetPasswordError' => { status: :unprocessable_entity, code: 'RESET_PASSWORD_ERROR',
                                message: I18n.t('exceptions.reset_password_error') },
      'Forbidden' => { status: :forbidden, code: 'FORBIDDEN',
                       message: I18n.t('exceptions.forbidden') },
      'RoleError' => { status: :forbidden, code: 'FORBIDDEN',
                       message: I18n.t('exceptions.role_error') },
      'LogoutError' => { status: :forbidden, code: 'FORBIDDEN',
                         message: I18n.t('exceptions.logout_error') },
      'ActiveRecord::RecordNotFound' => { status: :not_found, code: 'RECORD_NOT_FOUND',
                                          message: I18n.t('exceptions.record_not_found'),
                                          detail: I18n.t('exceptions.detail.record_not_found') },
      'ActiveRecord::RecordInvalid' => { status: :unprocessable_entity, code: 'RECORD_INVALID',
                                        message: I18n.t('exceptions.record_invalid') },
      'UserNotFound' => { status: :not_found,
                          code: 'USER_NOT_FOUND',
                          message: I18n.t('exceptions.user.not_found') },
      'UserNotVerified' => { status: :unprocessable_entity,
                            code: 'USER_NOT_VERIFIED',
                            message: I18n.t('exceptions.user.not_verified') },
      'ActionController::ParameterMissing' => { status: :bad_request,
                                                code: 'ParameterMissing',
                                                message: I18n.t('exceptions.user.parameter') }
    }.freeze

    EXCEPTIONS.each do |name, context|
      rescue_from name do |exception|
        detail = build_error_detail(exception, context)

        render status: context[:status],
               json: {
                 error: {
                   code: context[:code],
                   message: context[:message],
                   detail: detail
                 }
               }.compact
      end
    rescue StandardError
    end
  end

  private

  def build_error_detail(exception, context)
    if context[:status] == :unprocessable_entity
      exclusions = %w[LogoutError]

      if exclusions.include?(context[:code]) || !exception.record.respond_to?(:errors)
        begin
          JSON.parse(exception.message)
        rescue StandardError
          begin
            eval(exception.message)
          rescue StandardError
            errors = {}
            errors[context[:class]] = []
            errors[context[:class]] << exception.message
            errors
          end
        end
      else
        exception.record.errors.as_json
      end
    else
      exclusions = %w[RECORD_NOT_FOUND]
      exclusions.include?(context[:code]) ? context[:detail] : exception.message
    end
  end
end
