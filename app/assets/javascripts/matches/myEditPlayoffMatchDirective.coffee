'use strict'

angular.module('mainApp').directive 'myEditPlayoffMatch', ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        scope.$apply ->
          scope.match.$edited = angular.copy(scope.match)
