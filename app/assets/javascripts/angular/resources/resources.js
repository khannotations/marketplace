"use strict";

marketplace.factory("User", ["$resource", function($resource) {
  var skillUrl = "/users/:id/skills/:skill_id.json";
  var User = $resource("/users/:netid.json", {netid: "@netid"}, 
    {
      update: {method: "PUT"}, // The update action is not there by default
      getCurrent: {method: "GET", url: "/current_user.json"},
      addSkill: {method: "POST", url: skillUrl, params: {id: "@id"}},
      removeSkill: {method: "DELETE", url: skillUrl, params: {id: "@id"}}
    });

  return User;
}]).factory("Project", ["$resource", function($resource) {
  var Project = $resource("/projects/:id.json", {id: "@id"}, {
    update: {method: "PUT"}
  });
  return Project;
}]).factory("Opening", ["$resource", function($resource) {
  var Opening = $resource("/projects/:project_id/openings/:id.json",
    {project_id: "@project_id", id: "@id"},
    {
      update: {method: "PUT"},
      search: {method: "GET", url: "/openings/search", isArray: true}
    }
  );
  return Opening;
}]).factory("Skill", ["$resource", function($resource) {

}]);
