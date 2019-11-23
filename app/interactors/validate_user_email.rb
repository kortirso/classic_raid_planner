# Validate email of new user
class ValidateUserEmail
  include Interactor

  # required context
  # context.user
  # context.confirmation_token
  def call
    context.fail!(message: "Confirmation token can't be blank") unless context.confirmation_token.present?
    context.fail!(message: 'Confirmation token is invalid') if context.confirmation_token != context.user.confirmation_token
    context.user.update(confirmed_at: DateTime.now, confirmation_token: nil)
  end
end