"use strict";

marketplace.factory("User", ["$resource", function($resource) {
  var skillUrl = "/api/users/:id/skills/:skill_id.json";
  var User = $resource("/api/users/:id.json", {id: "@id"}, 
    {
      update: {method: "PUT"}, // The update action is not there by default
      getCurrent: {method: "GET", url: "/api/current_user.json"},
      addSkill: {method: "POST", url: skillUrl, params: {id: "@id"}},
      removeSkill: {method: "DELETE", url: skillUrl, params: {id: "@id"}}
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

}]);
