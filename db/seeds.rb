ActiveRecord::Base.transaction do
  seed_count = ENV['seed_count'] || 5

  p "Seeding users."
  User.create(
    email: 'admin@admin.com',
    password: '321321321',
    img_link: Faker::Avatar.image,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    admin: true,
    rank: 0)

  (seed_count ** 2).times do
    User.create(
      email: Faker::Internet.email,
      password: Faker::Internet.password(10, 20),
      img_link: Faker::Avatar.image,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      rank: 0)
  end

  p "Seeding tournaments."
  seed_count.times do |i|
    Tournament.create(
      name: "#{Faker::App.name}-#{i}",
      status: %w(not\ started completed in\ progress).sample,
      sports_kind: Faker::Team.sport,
      team_size: [i, 4].min + 1,
      user_ids: User.pluck(:id).sample(User.count - seed_count))
  end

  p "Seeding teams/rounds/matches/assessments."
  Tournament.all.each do |t|
    # seeding teams
    seed_count.times do
      player_ids = t.users.pluck(:id).sample(t.team_size)
      players = User.where(id: player_ids)
      team_name = players.map{ |u| "#{u.first_name} #{u.last_name.first}." }.join(' + ')

      players.each do |u|
        u.tournaments << t
        u.save
      end

      t.teams.create(
        name: team_name,
        user_ids: player_ids)

      # seeding rounds
      t.rounds.create()
    end

    # seeding matches
    games_count = [1, 2].sample

    t.rounds.each do |r|
      t.teams.each do |t1|
        t.teams.each do |t2|
          if t1 != t2
            games_count.times do
              r.matches.create(
                host_score: Faker::Number.between(1, 30),
                guest_score: Faker::Number.between(1, 30),
                host_team_id: t1.id,
                guest_team_id: t2.id)
            end
          end
        end
      end
    end

    # seeding assessments
    assessment_params = []

    t.users.each do |u1|
      t.users.each.with_index do |u2, i|
        if u1 != u2
          assessment_params.push("(#{i}, #{u1.id}, #{u2.id}, #{t.id}, '#{ Time.now }', '#{ Time.now }')")
        end
      end
    end

    sql = <<END_SQL
    INSERT INTO assessments
      ("score", "user_id", "rated_user_id", "tournament_id", "created_at", "updated_at")
    VALUES #{assessment_params.join(', ')}
END_SQL

    ActiveRecord::Base.connection.execute(sql)
  end
end
