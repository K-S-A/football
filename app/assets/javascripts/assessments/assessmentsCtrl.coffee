'use strict'

angular.module('mainApp').controller 'AssessmentsCtrl', [
  'User'
  (User) ->
    vm = this

    vm.participants = User.participants

    vm

]
