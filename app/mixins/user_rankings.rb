# UserRankings module, Calculates several user statistics.
module UserRankings
  def most_wins
    User.order('users.win_count DESC').limit(1).first
  end

  def league_leaders
    (User.all.sort_by(&:rating)).reverse.take(10)
  end

  def most_captains
    return false unless Team.any?
    most_captains = {}
    # Get all captain ids
    captain_ids_array = Team.all.pluck(:captain_id)
    # Hash mapping each value in the array to its frequency.
    freq = captain_ids_array.inject(Hash.new(0)) { |a, e| a[e] += 1; a }
    # Arrange by max frequency to find the user with the most captains.
    captain_id = captain_ids_array.max_by { |v| freq[v] }
    frequency = freq[captain_id]

    most_captains[:user] = User.find(captain_id)
    most_captains[:count] = frequency

    most_captains
  end

  def most_creations
    most_creations = {}
    # Get all creator ids
    creator_ids_array = Match.all.pluck(:creator_id)
    # Hash mapping each value in the array to its frequency.
    freq = creator_ids_array.inject(Hash.new(0)) { |a, e| a[e] += 1; a }
    # Arrange by max frequency to find the user with the most creations.
    creator_id = creator_ids_array.max_by { |v| freq[v] }
    frequency = freq[creator_id]

    most_creations[:user] = User.find(creator_id)
    most_creations[:count] = frequency

    most_creations
  end
end
