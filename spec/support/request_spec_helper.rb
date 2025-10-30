module RequestSpecHelper
  def auth_headers_for(user)
    jwt_payload = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
    token = jwt_payload[0]
    { 'Authorization' => "Bearer #{token}" }
  end
end
