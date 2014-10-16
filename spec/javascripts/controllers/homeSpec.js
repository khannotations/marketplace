//= require application
//= require angular-mocks

var $httpBackend = $cookieStore = $controller = $rootScope = null;
var createController = sampleUser = null;

describe("HomeCtrl", function() {
  beforeEach(module("Marketplace"));

  beforeEach(inject(function($injector) {
    $httpBackend = $injector.get("$httpBackend");
    $cookieStore = $injector.get("$cookieStore");
    $controller = $injector.get("$controller");
    $rootScope = $injector.get("$rootScope");

    sampleUser = {
      netid: "stan23",
      first_name: "stan",
      last_name: "the man"
    }
    $httpBackend.when("GET", "/current_user.json").respond(sampleUser);
    createController = function() {
      return $controller("HomeCtrl", {"$scope": $rootScope});
    };
  }));

  afterEach(function() {
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest();

    $cookieStore.remove("_marketplace_user"); // Clear cookie
  });

  it("gets current user on load when there isn't a cookie", function() {
    $cookieStore.remove("_marketplace_user");
    $httpBackend.expectGET("/current_user.json");
    createController();
    $httpBackend.flush();
  });

  it("doesn't make request when there is a cookie", function() {
    $cookieStore.put("_marketplace_user", sampleUser);
    createController();
  });

  it("sends search to correct URL", function() {
    createController();
    $httpBackend.expectGET("/openings/search?q=query").respond([
      { id: 1, name: "first" },
      { id: 2, name: "second"}
    ]);
    $rootScope.search("query");
    $httpBackend.flush();
    expect($rootScope.foundOpenings.length).toEqual(2);
  });

});
