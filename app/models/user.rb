class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  #validates_presence_of :email
  mount_uploader :image, ImageUploader
  has_many :authorizations
  has_many :widgets


  def self.new_with_session(params,session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"],without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def self.from_omniauth(auth, current_user)

    authorization = Authorization.where(:provider => auth.provider, :uid => auth.uid.to_s).first_or_initialize
    authorization.token = auth.credentials.token
    authorization.secret = auth.credentials.secret

    if authorization.user.blank?
      user = current_user || User.where('email = ?', auth["info"]["email"]).first
      p "="*170
      p auth.info
      p auth.info.name
      p auth.info.email
      if user.blank?
       user = User.new
       user.password = Devise.friendly_token[0,10]
       user.name = auth.info.name
       user.email = auth.info.email
       if auth.provider == "twitter" 
         user.save(:validate => false)
       else
         user.save
       end
     end
     authorization.username = auth.info.nickname
     authorization.user_id = user.id
     authorization.save
   end
   authorization.user
 end
end
