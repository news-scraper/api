class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  before_create do |user|
    user.api_key = user.generate_api_key
  end

  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(api_key: token)
    end
  end
end
