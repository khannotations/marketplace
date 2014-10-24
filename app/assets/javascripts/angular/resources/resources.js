"use strict";

marketplace.factory("User", ["$resource", function($resource) {
  // NOTE: User uses netid instead of id!
  var User = $resource("/api/users/:netid.json", {netid: "@netid"}, 
    {
      update: {method: "PUT"}, // The update action is not there by default
      getCurrent: {method: "GET", url: "/api/current_user.json"}
    });

  return User;
}]).factory("Project", ["$resource", function($resource) {
  var Project = $resource("/api/projects/:id.json", {id: "@id"}, {
    update: {method: "PUT"}
  });
  return Project;
}]).factory("Opening", ["$resource", function($resource) {
  var Opening = $resource("/api/projects/:project_id/openings/:id.json",
    {project_id: "@project_id", id: "@id"},
    {
      update: {method: "PUT"},
      search: {method: "GET", url: "/api/openings/search", isArray: true}
    }
  );
  // Don't change these without changing the backend values as well!
  Opening.PAY_TYPES = ["hourly", "lumpsum", "volunteer"]
  Opening.TIMEFRAMES = ["termtime", "summer", "full time"]

  return Opening;
}]).factory("Skill", ["$resource", function($resource) {
  var Skill = $resource("/api/skills");
  return Skill;
}]);
