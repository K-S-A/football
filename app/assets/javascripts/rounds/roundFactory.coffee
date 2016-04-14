'use strict'

angular.module('mainApp').factory 'Round', [
  'railsResourceFactory'
  'railsSerializer'
  (railsResourceFactory, railsSerializer) ->
    Round = railsResourceFactory(
      url: 'tournaments/{{tournamentId}}/rounds/{{id}}'
      name: 'round'
      serializer: railsSerializer ->
        @only 'id', 'mode', 'position')

#    Round.findByTournament = (tournamentId, id) ->
#      Round.$get('/tournaments/' + tournamentId + '/rounds/' + id)

#    Round.createByTournament = (tournamentId, params) ->
#      Round.$post('/tournaments/' + tournamentId + '/rounds', params)

    Round
]
