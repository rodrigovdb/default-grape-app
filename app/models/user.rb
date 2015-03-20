class User
  attr_accessor :id
  attr_accessor :public_key
  attr_accessor :access_token

  def self.authenticate(public_key, password)
    build_default_user
  end

  def self.find_by(attrs = {})
    return unless attrs.key?(:Xauthtoken)

    build_default_user
  end

  def generate_token
    Digest::MD5.hexdigest id.to_s + Time.new.to_s
  end

  def expired?
    return false
  end

private
  def self.build_default_user
    user              = User.new
    user.public_key   = user.generate_token
    user.access_token = user.generate_token

    user
  end
end
