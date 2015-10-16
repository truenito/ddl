# Match class, models a match (game) in the league, a match starts empty and
# finishes with 10 players, 2 teams (one winner and one loser).
class Match < ActiveRecord::Base
  has_many :teams
  has_many :match_tokens
  has_many :users, through: :match_tokens

  default_scope { order('created_at DESC') }
  scope :live, -> { where('status = ? or status = ?', 'waiting', 'playing') }

  # Checks if match is being played at the moment.
  def playing?
    status == 'playing'
  end

  # Checks if match has ended.
  def ended?
    status == 'ended'
  end

  # Checks if  match is canceled.
  def canceled?
    status == 'canceled'
  end

  # Checks if match is leaveable at the moment.
  def leavable?
    status != 'playing' && status != 'ended'
  end

  # Checks if match is joinable by players/waiting for players.
  def joinable?
    status == 'waiting'
  end
  alias_method :waiting?, :joinable?

  # Calculates the number of result votes a match has.
  def votes_number
    match_tokens.select { |token| token.result.present? }.count
  end

  def enough_vote_frequency?
    freq = Hash.new(0)
    voted_results = match_tokens.map(&:result)
    voted_results.each { |v| freq[v] += 1 }
    freq['radiant'] >= 6 || freq['canceled'] >= 6 || freq['dire'] >= 6 ? true : false
  end

  def vote_frequency
    freq = Hash.new(0)
    voted_results = match_tokens.map(&:result)
    voted_results.each { |v| freq[v] += 1 }
    freq
  end

  # If the match hasn't been canceled, has started but hasn't ended, and it has more than
  # 6 votes with the same result it's commitable (commit: save the result and end it).
  def committable?(freq = {})
    return false if status == 'ended' || status == 'canceled'
    enough_vote_frequency?
  end

  # Starts a match, creates the teams and changes status to playing
  # if enough Users have joined the match (10 Users).
  def start
    return false if match_tokens.count != 10
    create_teams
    self.status = 'playing'
    self.save!
  end

  # Cancels a match and unties Users from it.
  def cancel
    return false if playing? && votes_number < 6
    self.status = 'canceled'
    self.winner_team = nil

    match_tokens.destroy_all
    self.save!
  end

  # Interface to create balanced teams.
  def create_teams
    # Get relevant players data and balance for team creation.
    players_pool = users.pluck(:user_id, :rating)
    balanced_teams_hash = balance_players(players_pool)

    # Create real teams for match with the balanced team hash.
    Team.create_for_match(balanced_teams_hash, id)
    save_users_and_attributes(:id, :name, :rating, :status,
                              :facebook_link, :donator,
                              :win_count, :lose_count)
  end

  # Balance interface (team distribution).
  def balance_players(players_pool_array)
    @balanced = false
    @min_separation = 3
    @shuffles = 0

    while @balanced == false
      players_pool_array.shuffle!
      @shuffles += 1
      distribute_players players_pool_array

      check_separation @radiant_avg, @dire_avg, @min_separation
    end

    assign_teams @radiant_array, @dire_array
  end

  # Distributes players between radiant and dire from a shuffled player array.
  def distribute_players(players_pool_array)
    @radiant_array, @radiant_avg = players_pool_array.first(5), 0
    @dire_array, @dire_avg = players_pool_array.last(5), 0

    @radiant_array.each { |player| @radiant_avg += player[1] }
    @dire_array.each { |player| @dire_avg += player[1] }
  end

  # Checks if team rating averages meet minimum separation, if not reshuffles,
  # additionally, checks if if it's needed to increase the minimun separation.
  def check_separation(radiant_avg, dire_avg, min_separation)
    if (radiant_avg - dire_avg).abs < min_separation
      @balanced = true
    else
      @balanced = false
      if @shuffles > 1000
        @min_separation += 3
        @shuffles = 0
      end
    end
  end

  # Assigns the players to a temp team hash in order to create the real teams.
  def assign_teams(radiant_array, dire_array)
    dire = []
    radiant = []
    radiant_array.each { |player| radiant << User.find(player.first) }
    dire_array.each { |player| dire << User.find(player.first) }

    { radiant: radiant, dire: dire }
  end

  # Saves frozen user attributes for future reference i.e: actual rating at the
  # time the match happened.
  def save_users_and_attributes(*stats)
    players_pool_with_stats = users.select(stats)
    self.users_and_stats = players_pool_with_stats.as_json
  end

  # Commit and finalize the Match if enough votes have been processed.
  # 6 votes is enough to declare a winner.
  def commit
    return false unless committable?
    result = vote_frequency.reject { |_k, v| v < 6 }.keys.first
    if result == 'radiant' || result == 'dire'
      winner_team = teams.where(side: result)
      loser_team = (teams - winner_team).first
      winner_team = winner_team.first

      update_player_stats(winner_team, loser_team, result)
      finalize_match(result)
    else
      cancel
    end
  end

  # TODO: @truenito: Split into little methods and make it an interface.
  def update_player_stats(winner_team, loser_team, result)
    # update win counts
    winner_team.users.each { |u| c = u.win_count + 1; u.win_count = c; u.save! }
    loser_team.users.each { |u| c = u.lose_count + 1; u.lose_count = c; u.save! }

    # Check how much player rating going to change.
    rating_change = 0
    rating_change = (Team.rating_change((winner_team.users.sum(:rating) / 5),
                                        (loser_team.users.sum(:rating) / 5)))

    # TODO: @truenito simplify this, DRY up/split to methods.
    # Decrease losing team's rating and increase winner team's rating
    # based on the rating change.
    if result == 'radiant'
      winner_team.users.each { |u| c = u.rating + rating_change[:dire]; u.rating = c; u.save! }
      loser_team.users.each { |u| c = u.rating - rating_change[:dire]; u.rating = c; u.save! }
    else
      winner_team.users.each { |u| c = u.rating + rating_change[:radiant]; u.rating = c; u.save! }
      loser_team.users.each { |u| c = u.rating - rating_change[:radiant]; u.rating = c; u.save! }
    end
  end

  # Saves match result information for teams and sets "ended" status.
  def finalize_match(result)
    if result == 'radiant'
      self.winner_team = false
    elsif result == 'dire'
      self.winner_team = true
    end
    match_tokens.each { |t| t.result = winner_team; t.save! }

    self.status = 'ended'
    self.save!
  end
end
