class Match < ActiveRecord::Base
  has_many :users, :through => :match_tokens
  has_many :teams
  has_many :match_tokens

  validates_length_of :name, :minimum => 5, :maximum => 90, :allow_blank => false
  validates_length_of :password, :minimum => 3, :maximum => 10, :allow_blank => false

  def create_teams
    players_pool_array = self.users.pluck(:user_id, :rating)
    balanced_teams_hash = balance_players(players_pool_array)

    Team.create_for_match(balanced_teams_hash, self.id)
  end

  # Balance algorithm (team distribution).
  # TODO @truenito: Divide into smaller methods and make it cleaner.
  def balance_players(players_pool_array)
    balanced = false
    min_rating_separation = 3
    shuffles = 0
    radiant_team, dire_team = [], []

    while balanced == false
      players_pool_array.shuffle!
      shuffles += 1
      radiant_team_array, radiant_team_avg = players_pool_array.first(5), 0
      dire_team_array, dire_radiant_team_avg = players_pool_array.last(5), 0

      radiant_team_array.each{|player| radiant_team_avg += player[1] }
      dire_team_array.each{|player| dire_radiant_team_avg += player[1] }

      (radiant_team_avg - dire_radiant_team_avg).abs < min_rating_separation ? balanced = true : balanced = false
      if shuffles > 1000
        min_rating_separation += 3
        shuffles = 0
      end
    end

    radiant_team_array.each{|player| radiant_team << User.find(player.first)}
    dire_team_array.each{|player| dire_team << User.find(player.first)}

    return { radiant_team: radiant_team, dire_team: dire_team}
  end

  # Match commit interface.
  def commit_match
    if committable?
      result = @freq.reject{|k,v|v < 6}.keys.first # get the result with the 6 votes.
      if result == 'radiant' || result == 'dire'
        winner_team = self.teams.where(side: result)
        loser_team = (self.teams - winner_team).first
        winner_team = winner_team.first

        update_player_stats(winner_team, loser_team, result)
        finalize_match(winner_team, result)
      else
        cancel_match
      end
    end
  end

  # TODO @truenito: Split into little methods and make it an interface.
  def update_player_stats(winner_team, loser_team, result)
    # update win counts
    winner_team.users.each{|u| c = u.win_count + 1; u.win_count = c; u.save!}
    loser_team.users.each{|u| c = u.lose_count + 1; u.lose_count = c; u.save!}

    # update ratings.
    rating_change = 0
    rating_change = (Team.rating_change((winner_team.users.sum(:rating) / 5), (loser_team.users.sum(:rating) / 5)))

    # logic is: Depending on who won/lost substract corresponding amount from both teams.
    if result == 'radiant'
      winner_team.users.each{|u| c = u.rating + rating_change[:dire]; u.rating = c; u.save!}
      loser_team.users.each{|u| c = u.rating - rating_change[:dire]; u.rating = c; u.save!}
    else
      winner_team.users.each{|u| c = u.rating + rating_change[:radiant]; u.rating = c; u.save!}
      loser_team.users.each{|u| c = u.rating - rating_change[:radiant]; u.rating = c; u.save!}
    end
  end

  def finalize_match(winner_team, result)
    if result == 'radiant'
      winner_team_bool = false
    elsif result == 'dire'
      winner_team_bool = true
    end
    self.match_tokens.each{|t| t.result = winner_team_bool; ; t.save!}
    self.winner_team = winner_team_bool

    self.status = 'ended'
    self.save!
  end

  def cancel_match
    self.match_tokens.destroy_all!
    self.status = 'canceled'
    self.winner_team = nil

    self.save!
  end

  # match statuses/interactions.
  def votes_number
    self.match_tokens.select{|token| token.result != nil}.count
  end

  def joinable? ; self.status == 'waiting'; end
  alias_method :waiting?, :joinable?

  def playing? ; self.status == 'playing' ; end

  def canceled? ; self.status == 'canceled'; end

  def ended? ; self.status == 'ended'; end

  def leavable? ; !(self.status == 'playing'); end

  def committable?
    return false if self.status == 'ended'
    voted_results = self.match_tokens.map(&:result)
    @freq = Hash.new(0)
    voted_results.each do |v|
      @freq[v] += 1
    end

    @freq['radiant'] >= 6 || @freq['canceled'] >= 6 || @freq['dire'] >= 6 ? true : false
  end

end
