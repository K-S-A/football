'use strict'

angular.module('mainApp').directive 'animateOnChange', [
  '$timeout'
  '$animate'
  ($timeout, $animate) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      scope.$watch(attrs.animateOnChange, (newVal, oldVal) ->
        if newVal != oldVal
          $animate.addClass(element, 'select-changed').then ->
            $timeout ->
              $animate.removeClass(element, 'select-changed')
            , 500)
]
