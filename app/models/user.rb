# User class, all users registered entities, a user may or may not be
# authenticated with Facebook (but needs to in order to play in the league),
# all users are players.
class User < ActiveRecord::Base
  include UserPrivileges
  extend UserRankings

  has_and_belongs_to_many :teams
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]
  has_many :match_tokens
  has_many :matches, through: :match_tokens

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :description, length: { minimum: 10, maximum: 200, allow_blank: false }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def leave_match(match)
    match.match_tokens.find_by(user_id: id).delete
  end

  def win_rate
    if lose_count + win_count.to_f == 0
      0
    else
      (win_count.to_f / (lose_count + win_count.to_f) * 100).to_i
    end
  end

  rails_admin do
    object_label_method :to_label
  end

  def admin?
    admin
  end

  def facebook_authed?
    provider == 'facebook'
  end

  def joinable?
    facebook_authed? && !match_tokens.where(result: nil).any?
  end

  def unjoinable?
    !facebook_authed? || matches.last.playing?
  end

  def to_label
    "#{name} - #{email}"
  end

  def played_matches
    matches.select { |x| x.status == 'ended' }
  end
end
