"use strict";

marketplace.factory("User", ["$resource", function($resource) {
  // NOTE: User uses netid instead of id!
  var User = $resource("/api/users/:netid.json", {netid: "@netid"}, 
    {
      update: {method: "PUT"}, // The update action is not there by default
      getCurrent: {method: "GET", url: "/api/current_user.json"},
      search: {method: "GET", url: "/api/search/users.json", isArray: true},
      toggleStar: {method: "PUT", url: "/api/star/:project_id.json"}
    });

  User.prototype.isStarred = function(id) {
    if (!this.favorite_project_ids) {
      return false;
    }
    return this.favorite_project_ids.indexOf(id) !== -1;
  }

  return User;
}]).factory("Project", ["$resource", function($resource) {
  var Project = $resource("/api/projects/:id.json", {id: "@id"}, {
    update: {method: "PUT"},
    search: {method: "GET", url: "/api/search/projects", isArray: true},
    renew:  {method: "PUT", url: "/api/projects/:id/renew"},
    contact: {method: "POST", url: "/api/projects/:id/contact"},
    getUnapproved: {method: "GET", isArray: true, url: "/api/projects/unapproved.json"},
    approve: {method: "PUT", url: "/api/projects/:id/approve.json"}
  });

  // Don't change these without changing the backend values as well!
  Project.PAY_TYPES = ["hourly", "lumpsum", "volunteer"]
  Project.TIMEFRAMES = ["termtime", "summer", "fulltime"]
  return Project;
}]).factory("Skill", ["$resource", function($resource) {
  var Skill = $resource("/api/skills");
  return Skill;
}]);
