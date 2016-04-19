'use strict'

angular.module('mainApp').factory 'Match', [
  'railsResourceFactory'
  'railsSerializer'
  (railsResourceFactory, railsSerializer) ->
    Match = railsResourceFactory(
      url: 'rounds/{{roundId}}/matches/{{id}}'
      name: 'match'
      serializer: railsSerializer ->
        # TODO: possible issues
        @only 'id', 'hostTeamId', 'guestTeamId', 'hostTeam', 'guestTeam', 'hostScore', 'guestScore', 'teams', 'teamIds', 'count')

    Match.beforeRequest (data) ->
      if data
        data['host_team_id'] ||= data.host_team && data.host_team.id
        data['guest_team_id'] ||= data.guest_team && data.guest_team.id

        delete data.host_team
        delete data.guest_team

      data

    Match
]
