'use strict'

angular.module('mainApp').directive 'myAddPlayoffMatch', [
  'Round'
  'Match'
  (Round, Match) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        nextId = if scope.match then scope.match.id else null

        new Match(nextId: nextId, roundId: Round.current.id).create().then (data) ->
          scope.match.children ||= []
          scope.match.children.push(data)
]
