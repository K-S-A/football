'use strict'

angular.module('mainApp').directive 'myUpdatePlayoffMatch', [
  'Match'
  'Round'
  (Match, Round) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'submit', ->
        path = '/rounds/' + Round.current.id + '/matches/' + scope.match.id

        Match.$patch(path, scope.match.$edited).then (data) ->
          angular.extend(scope.match, data)
          scope.match.$edited = null

]
