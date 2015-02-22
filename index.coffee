app = angular.module 'footApp', ['ngStorage']

app.config ($httpProvider) ->
  delete $httpProvider.defaults.headers.common['X-Requested-With'];

app.controller 'footCtrl', ($scope, program, player) ->

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
      player.play program

  $scope.onClickRetry = init

  init()

app.service 'program', ($http, $q, _, player) ->
  this.list = () ->
    req =
      method : 'GET'
      url    : 'https://www.kimonolabs.com/api/3kplvmje'
      params :
        apikey    : 'YmPUBuAN7hpEa3LbfEsA5zAgdEs0qcuW'
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
        programs = JSON.parse res.list.data.results.collection1[0].programs
        list = programs.message
        resc = res.info.data.results.resources
        _.map list, (v) -> _.extend v, _.find resc, (r) -> r.url.indexOf(v.fileName) > 0
      .then (res) ->
        res.map (p) -> _.extend p, progress: player.lastProgress p

  this

app.service 'player', ($rootScope, $localStorage) ->
  player  = audiojs.createAll()[0]
  element = player.element
  element.addEventListener 'pause',   () => this.mark()
  element.addEventListener 'seeked',  () => this.mark()
  element.addEventListener 'play',    () -> console.log 'play'
  element.addEventListener 'error',   () -> console.log 'error'

  this.play = (program) ->
    position = this.lastPosition program.radioId
    player.id = program.radioId
    player.load program.url + "#t=#{position}"
    player.play()

  this.lastPosition = (id) ->
    Math.round $localStorage[id] ? 0

  this.lastProgress = (program) ->
    lastPosition = this.lastPosition program.radioId
    if lastPosition is 0 then return '0%'

    "#{lastPosition * 100 / program.totalSecond}%"

  this.mark = () ->
    $localStorage[player.id] = element.currentTime
    $rootScope.$apply()

  this

app.factory '_', () -> window._
app.filter 'trusted', ($sce) -> (url) -> $sce.trustAsResourceUrl url
