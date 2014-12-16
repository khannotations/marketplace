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

project = Project.create({
  name: "The Yale Projects Board",
  description: "As Yale tech community continues to grow and become more robust, more and more projects—either those started independently by students or in connection to an academic department—are being created. Often, those project leaders are faced with the challenging problem of finding talented programmers, designers, and engineers to join their teams, and are unsure where to search.

We want to solve this coordination with an online projects board that allows those looking for programmers, designers, and engineers (“leaders”) to post their ideas online and recruit talent, and give those looking for projects (“members”) a central location to start their search. The goal is to be professional enough that people take themselves and others seriously on the site, but not so seriously that people short on experience are intimidated. This would also present an exciting opportunity to aggregate data about what kinds of projects are being created at Yale, as well as what skills are most desired.",
  approved: true
})
project.leaders << rafi
print "creating openings..."
openings = [
  {
    name: "Frontend developer",
    description: "A quick-thinking expert at Javascript and CSS. You will work with a team of 1-100 people building the front-end of our super-useless app. Must be a nice guy to boot!",
    pay_amount: "20",
    pay_type: Opening::PAY_TYPE_HOURLY,
    timeframe: Opening::TIMEFRAME_TERM
  },
  {
    name: "Backend developer",
    description: "A master of Ruby, Rails, Postgres and all other technologies",
    pay_amount: "500",
    pay_type: Opening::PAY_TYPE_LUMPSUM,
    timeframe: Opening::TIMEFRAME_TERM
  },
  {
    name: "iOS Wizard for the Masses",
    description: "Plz Plz Plz help us build an iPhone app for a good cause. Skills required are iOS development (duh) like objective c and the related technologies also please be good at what you do we don't want to waste our time or your time.",
    pay_amount: "15",
    pay_type: Opening::PAY_TYPE_HOURLY,
    timeframe: Opening::TIMEFRAME_TERM
  }
]
openings.each {|o| Opening.create!(o.merge(project_id: project.id))}
puts "done!"

print "creating skills..."
skills = ["Javascript", "CoffeeScript", "Ruby on Rails", "Ruby", "CSS", "SASS",
"Python", "C", "C++", "Java", "Adobe Photoshop", "Adobe Illustrator",
"Adobe InDesign", "Postgres", "HTML", "Django", "jQuery", "AngularJS", "Databases",
"Objective-C", "iOS", "Android", "Swift", "UI/UX Design", "Go (language)",
"Wordpress"]
skills.each {|s| Skill.create!(name: s)}
puts "done!"

print "adding skills to openings..."
Opening.first.skills << Skill.find_by(name: "Javascript")
Opening.first.skills << Skill.find_by(name: "CSS")
Opening.first.skills << Skill.find_by(name: "SASS")
Opening.second.skills << Skill.find_by(name: "Ruby")
Opening.second.skills << Skill.find_by(name: "Ruby on Rails")
Opening.second.skills << Skill.find_by(name: "CSS")
Opening.second.skills << Skill.find_by(name: "SASS")
Opening.second.skills << Skill.find_by(name: "Java")
Opening.second.skills << Skill.find_by(name: "C")
Opening.third.skills << Skill.find_by(name: "C++")
Opening.second.skills << Skill.find_by(name: "Postgres")
Opening.second.skills << Skill.find_by(name: "HTML")

rafi.skills << Skill.find_by(name: "Javascript")
rafi.skills << Skill.find_by(name: "CSS")
puts "done!"
