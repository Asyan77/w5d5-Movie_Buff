def eighties_b_movies
  Movie
    .select(:id, :title, :yr, :score)
    .where('yr BETWEEN 1980 AND 1989 AND score BETWEEN 3 AND 5')

    # .where(yr: 1980..1989).where(score: 3..5)
end

def bad_years
  Movie
    .group('movies.yr')
    .having('MAX(score) <= 8')
    .pluck(:yr)
end

def cast_list(title)
  Actor
    .select(:id, :name)
    .joins(:movies)
    # .where(movies: { title: (title) })
    .where('movies.title = (?)', title)
    .order('castings.ord')
  
end

def vanity_projects
  Movie
    .select(:id, :title, 'actors.name')
    .joins(:actors)
    .where('movies.director_id = castings.actor_id')
    .where(castings: { ord: 1 })
end

def most_supportive
  Actor
    .select(:id, :name, 'COUNT(castings.actor_id) as roles')
    .joins(:castings)
    .where.not(castings: { ord: 1 })
    .group('actors.id')
    .order('roles DESC')
    .limit(2)
end