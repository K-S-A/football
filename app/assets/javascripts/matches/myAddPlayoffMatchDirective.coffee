'use strict'

angular.module('mainApp').directive 'myAddPlayoffMatch', [
  'Round'
  'Match'
  (Round, Match) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        if scope.match
          new Match(nextId: scope.match.id, roundId: Round.current.id).create().then (data) ->
            scope.match.children ||= []
            scope.match.children.push(data)
        else
          new Match(nextId: null, roundId: Round.current.id).create().then (data) ->
            scope.vm.matches.push(data)
]
