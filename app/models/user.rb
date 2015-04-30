class User < ActiveRecord::Base
  include UserPrivileges
  extend UserRankings

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]
  has_many :match_tokens
  has_many :matches, :through => :match_tokens
  has_and_belongs_to_many :teams

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates_length_of :description, :minimum => 10, :maximum => 200, :allow_blank => false


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def leave_match(match)
    token = match.match_tokens.where(user_id: self.id).first
    token.delete
  end

  def win_rate
    if self.lose_count + self.win_count.to_f == 0
      0
    else
      (self.win_count.to_f / (self.lose_count + self.win_count.to_f) * 100).to_i
    end
  end

  rails_admin do
    object_label_method :to_label
  end

  def to_label
    "#{name} - #{email}"
  end

  def admin?
    admin
  end

  def facebook_authed?
    self.provider == 'facebook'
  end

  def joinable?
    facebook_authed? && !self.match_tokens.where(result: nil).any?
  end

end
