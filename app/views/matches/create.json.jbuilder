if @match
  json.partial! 'matches/match', match: @match
else
  json.array! @matches, partial: 'matches/match', as: :match
end
