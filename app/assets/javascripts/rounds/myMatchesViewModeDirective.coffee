'use strict'

angular.module('mainApp').directive 'myMatchesViewMode', ->
    restrict: 'E'
    template: '<select class="form-control input-lg" data-ng-model: "vm.viewMode" data-ng-options="mode as mode for mode in vm.viewModes"></select>'
