'use strict'

angular.module('mainApp').directive 'myGenerateMatches', [
  'Match'
  'Round'
  '$window'
  (Match, Round, $window) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        if $window.confirm('Generate matches?')
          path = '/rounds/' + Round.current.id + '/matches'
          params =
            teamIds: Round.current.teams.map (team) ->
              team.id
            count: scope.vm.count

          Match.$post(path, params).then (data) ->
            data.forEach (match) ->
              scope.vm.matches.push(match)
]
