app = angular.module 'footApp', []

app.config ($httpProvider) ->
  delete $httpProvider.defaults.headers.common['X-Requested-With'];

app.controller 'footCtrl', ($scope, program) ->
  init = () ->
    program.fetch().then (res) ->
      $scope.programs = res
      $scope.isError = false
    .catch (e) ->
      console.error e
      $scope.isError = true

  $scope.onClickList = (program) -> 
    if program.status == 4
      $scope.selected = program
      $scope.player.load program.url
      $scope.player.play()

  $scope.onClickRetry = init

  audiojs.events.ready () ->
    p = audiojs.createAll()
    $scope.player= p[0]
    p[0].element.addEventListener 'pause',   () -> console.log 'paused'
    p[0].element.addEventListener 'play',    () -> console.log 'play'
    p[0].element.addEventListener 'error',   () -> console.log 'error'
    p[0].element.addEventListener 'suspend', () -> console.log 'suspend'

  init()

app.service 'program', ($http, $q, _) ->
  this.list = () ->
    req =
      method : 'GET'
      url    : 'https://www.kimonolabs.com/api/3kplvmje'
      params :
        apikey    : 'YmPUBuAN7hpEa3LbfEsA5zAgdEs0qcuW'
        kimmodify : '1'
    $http req

  this.info = () ->
    req =
      method : 'GET'
      url    : 'https://www.kimonolabs.com/api/dumtajyi'
      params :
        apikey    : 'YmPUBuAN7hpEa3LbfEsA5zAgdEs0qcuW'
    $http req

  this.fetch = () ->
    $q.all { list : this.list(), info : this.info() }
      .then (res) ->
        list = res.list.data.results.collection1.message
        resc = res.info.data.results.resources
        _.map list, (v) -> _.extend v, _.find resc, (r) -> r.url.indexOf(v.fileName) > 0

  this

app.factory '_', () -> window._
app.filter 'trusted', ($sce) -> (url) -> $sce.trustAsResourceUrl url
