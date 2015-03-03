rafi = User.create({
  "first_name"=>"Rafi",
  "last_name"=>"Khan",
  "netid"=>"fak23",
  "email"=>"faiaz.khan@yale.edu",
  "year"=>"2016",
  "college"=>"Pierson College",
  "division"=>"Yale College",
  "title"=>nil,
  "bio"=>"Rafi is a senior and loves to push buttons on the computer. He hopes you find 
  a sweet project on the Board.",
  "is_admin"=>true,
  });

bobby = User.create({
  "first_name"=>"Bobby",
  "last_name"=>"Dresser",
  "netid"=>"rmd46",
  "email"=>"bobby.dresser@yale.edu",
  "year"=>"2015",
  "college"=>"Pierson College",
  "division"=>"Yale College",
  "title"=>nil,
  "bio"=>"Bobby is a senior Computer Science major in Pierson. He likes cats and 2px border radius.",
  "is_admin"=>true,
  });


print "creating projects..."
projects = [
  {
    name: "Frontend developer",
    overview: "A small team of elite(ish) developers that are making something cool!",
    project_description: "This is the best senior project ever!! Please join.",
    job_description: "A quick-thinking expert at Javascript and CSS. You will work with a team of 1-100 people building the front-end of our super-useless app. Must be a nice guy to boot!",
    pay_amount: "20",
    pay_type: Project::PAY_TYPE_HOURLY,
    timeframe: Project::TIMEFRAME_TERM,
    approved: true
  },
  {
    name: "Backend developer",
    overview: "A small team of elite(ish) developers that are making something cool!",
    project_description: "This is the best senior project ever!! Please join.",
    job_description: "A master of Ruby, Rails, Postgres and all other technologies",
    pay_amount: "500",
    pay_type: Project::PAY_TYPE_LUMPSUM,
    timeframe: Project::TIMEFRAME_TERM,
    approved: true
  }
]
projects.each do |p|
  project = Project.create!(p);
  project.leaders << rafi
  project.save
end
puts "done!"

print "creating skills..."
skills = ["Javascript", "CoffeeScript", "Ruby on Rails", "Ruby", "CSS", "SASS",
"Python", "C", "C++", "Java", "Adobe Photoshop", "Adobe Illustrator",
"Adobe InDesign", "Postgres", "HTML", "Django", "jQuery", "AngularJS", "Databases",
"Objective-C", "iOS", "Android", "Swift", "UI/UX Design", "Go (language)",
"Wordpress"]
skills.each {|s| Skill.create!(name: s)}
puts "done!"

print "adding skills to projects..."
Project.first.skills << Skill.find_by(name: "Javascript")
Project.first.skills << Skill.find_by(name: "CSS")
Project.first.skills << Skill.find_by(name: "SASS")
Project.second.skills << Skill.find_by(name: "Ruby")
Project.second.skills << Skill.find_by(name: "Ruby on Rails")
Project.second.skills << Skill.find_by(name: "CSS")
Project.second.skills << Skill.find_by(name: "SASS")
Project.second.skills << Skill.find_by(name: "Java")
Project.second.skills << Skill.find_by(name: "C")
Project.second.skills << Skill.find_by(name: "Postgres")
Project.second.skills << Skill.find_by(name: "HTML")

rafi.skills << Skill.find_by(name: "Javascript")
rafi.skills << Skill.find_by(name: "CSS")
puts "done!"
