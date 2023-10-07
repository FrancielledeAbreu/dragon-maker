module JwtAuthenticatable
  extend ActiveSupport::Concern

  def decoded_token
    return unless request.headers['Authorization']

    token = request.headers['Authorization'].split(' ')[1]
    begin
      JWT.decode(token, 'your_secret', true, algorithm: 'HS256')
    rescue JWT::DecodeError
      nil
    end
  end

  def current_user
    return unless decoded_token

    user_id = decoded_token[0]['user_id']
    User.find_by(id: user_id)
  end

  def logged_in?
    !!current_user
  end

  def authorized
    render json: { error: 'Please log in' }, status: :unauthorized unless logged_in?
  end
end
