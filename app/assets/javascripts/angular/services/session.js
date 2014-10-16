"use strict";

angular.module("Marketplace")
	.service("Session", function(){
		this.create = function(r){
			this.first_name = r.first_name;
			this.last_name = r.last_name;
			this.nedit = r.netid;
			this.email = r.email;
			this.year = r.year;
			this.college = r.college;
			this.division = r.division;
			this.title = r.title;
			this.is_admin = r.is_admin;
			this.github_url = r.github_url;
			this.linkedin_url = r.linkedin_url;
			this.resume = r.resume;
			this.bio = r.bio;
			this.past_experiences = r.past_experiences;
		};

		this.destroy = function(r){
			for(var p in r){
				if(this.hasOwnProperty(p)){
					this[p] = null;
				}
			}
		};

		return this;

	})