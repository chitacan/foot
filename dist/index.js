// Generated by CoffeeScript 1.9.0
(function() {
  var app;

  app = angular.module('footApp', []);

  app.config(function($httpProvider) {
    return delete $httpProvider.defaults.headers.common['X-Requested-With'];
  });

  app.controller('footCtrl', function($scope, program) {
    var init;
    init = function() {
      return program.fetch().then(function(res) {
        $scope.programs = res;
        return $scope.isError = false;
      })["catch"](function(e) {
        console.error(e);
        return $scope.isError = true;
      });
    };
    $scope.onClickList = function(program) {
      if (program.status === 4) {
        this.player.load(program.url);
        return this.player.play();
      }
    };
    $scope.onClickRetry = init;
    audiojs.events.ready(function() {
      var p;
      p = audiojs.createAll();
      $scope.player = p[0];
      p[0].element.addEventListener('pause', function() {
        return console.log('paused');
      });
      p[0].element.addEventListener('play', function() {
        return console.log('play');
      });
      p[0].element.addEventListener('error', function() {
        return console.log('error');
      });
      return p[0].element.addEventListener('suspend', function() {
        return console.log('suspend');
      });
    });
    return init();
  });

  app.service('program', function($http, $q, _) {
    this.list = function() {
      var req;
      req = {
        method: 'GET',
        url: 'https://www.kimonolabs.com/api/3kplvmje',
        params: {
          apikey: 'YmPUBuAN7hpEa3LbfEsA5zAgdEs0qcuW',
          kimmodify: '1'
        }
      };
      return $http(req);
    };
    this.info = function() {
      var req;
      req = {
        method: 'GET',
        url: 'https://www.kimonolabs.com/api/dumtajyi',
        params: {
          apikey: 'YmPUBuAN7hpEa3LbfEsA5zAgdEs0qcuW'
        }
      };
      return $http(req);
    };
    this.fetch = function() {
      return $q.all({
        list: this.list(),
        info: this.info()
      }).then(function(res) {
        var list, resc;
        list = res.list.data.results.collection1.message;
        resc = res.info.data.results.resources;
        return _.map(list, function(v) {
          return _.extend(v, _.find(resc, function(r) {
            return r.url.indexOf(v.fileName) > 0;
          }));
        });
      });
    };
    return this;
  });

  app.factory('_', function() {
    return window._;
  });

  app.filter('trusted', function($sce) {
    return function(url) {
      return $sce.trustAsResourceUrl(url);
    };
  });

}).call(this);
