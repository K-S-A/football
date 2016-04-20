'use strict'

angular.module('mainApp').directive 'myDeleteTournament', [
  '$window'
  ($window) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', (e) ->
        e.stopPropagation()

        if $window.confirm('Remove tournament?')
          scope.vm.delete(scope.$index)
]
