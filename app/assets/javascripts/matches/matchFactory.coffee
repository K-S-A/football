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
        @only 'id', 'hostTeamId', 'guestTeamId', 'hostTeam', 'guestTeam', 'hostScore', 'guestScore', 'teams', 'teamIds', 'count', 'nextId')

    Match.beforeRequest (data) ->
      if data
        data['host_team_id'] ||= data.host_team && data.host_team.id
        data['guest_team_id'] ||= data.guest_team && data.guest_team.id

        delete data.host_team
        delete data.guest_team

      data

    Match.rootNode = (arr) ->
      for match in arr
        return match unless match.nextId

    Match.toTree = (arr, parent, tree) ->
      tree ||= []
      parent ||= { id: null }

      children = arr.filter (match) ->
        match.nextId == parent.id

      if children != []
        if parent.id
          parent.children = children
        else
          tree = children

        children.forEach (match) ->
          Match.toTree(arr, match)

      tree

    Match.generate = (roundId, gamesCount) ->
      path = '/rounds/' + roundId + '/matches/generate'
      Match.$post(path, count: gamesCount)

    Match.prototype.teams = ->
      [@hostTeam, @guestTeam]

    Match
]
