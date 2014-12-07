"use strict";

marketplace.factory("User", ["$resource", function($resource) {
  // NOTE: User uses netid instead of id!
  var User = $resource("/api/users/:netid.json", {netid: "@netid"}, 
    {
      update: {method: "PUT"}, // The update action is not there by default
      getCurrent: {method: "GET", url: "/api/current_user.json"},
      search: {method: "GET", url: "/api/search/users", isArray: true},
      toggleStar: {method: "PUT", url: "/api/star/:opening_id"} // Toggle starred status
    });

  return User;
}]).factory("Project", ["$resource", function($resource) {
  var Project = $resource("/api/projects/:id.json", {id: "@id"}, {
    update: {method: "PUT"},
    getUnapproved: {method: "GET", isArray: true, url: "/api/projects/unapproved.json"},
    approve: {method: "PUT", url: "/api/projects/:id/approve.json"}
  });
  return Project;
}]).factory("Opening", ["$resource", function($resource) {
  var Opening = $resource("/api/openings/:id.json", {id: "@id"},
    {
      update: {method: "PUT"},
      search: {method: "GET", url: "/api/search/openings", isArray: true},
      renew:  {method: "PUT", url: "/api/openings/:id/renew"}
    }
  );
  // Don't change these without changing the backend values as well!
  Opening.PAY_TYPES = ["hourly", "lumpsum", "volunteer"]
  Opening.TIMEFRAMES = ["termtime", "summer", "fulltime"]

  return Opening;
}]).factory("Skill", ["$resource", function($resource) {
  var Skill = $resource("/api/skills");
  return Skill;
}]);
