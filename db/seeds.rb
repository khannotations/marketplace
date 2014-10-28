rafi = User.create({
  "first_name"=>"Rafi",
  "last_name"=>"Khan",
  "netid"=>"fak23",
  "email"=>"faiaz.khan@yale.edu",
  "year"=>"2016",
  "college"=>"Pierson College",
  "division"=>"Yale College",
  "title"=>nil,
  "is_admin"=>true,
  });

project = Project.create({
  name: "The Yale Projects Board",
  description: "As Yale tech community continues to grow and become more robust, more and more projects—either those started independently by students or in connection to an academic department—are being created. Often, those project leaders are faced with the challenging problem of finding talented programmers, designers, and engineers to join their teams, and are unsure where to search.

We want to solve this coordination with an online projects board that allows those looking for programmers, designers, and engineers (“leaders”) to post their ideas online and recruit talent, and give those looking for projects (“members”) a central location to start their search. The goal is to be professional enough that people take themselves and others seriously on the site, but not so seriously that people short on experience are intimidated. This would also present an exciting opportunity to aggregate data about what kinds of projects are being created at Yale, as well as what skills are most desired."
})
project.leaders << rafi
print "creating openings..."
openings = [
  {
    name: "Frontend developer",
    description: "A quick-thinking expert at Javascript and CSS",
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
  }
]
openings.each {|o| Opening.create!(o.merge(project_id: project.id))}
puts "done!"

print "creating skills..."
skills = ["Javascript", "CoffeeScript", "Ruby on Rails", "Ruby", "CSS", "SASS",
"Python", "C", "C++", "Java", "Adobe Photoshop", "Adobe Illustrator",
"Adobe InDesign", "Postgres"]
skills.each {|s| Skill.create!(name: s)}
puts "done!"

print "adding skills to openings..."
Opening.first.skills << Skill.find_by(name: "Javascript")
Opening.first.skills << Skill.find_by(name: "CSS")
Opening.first.skills << Skill.find_by(name: "SASS")
Opening.second.skills << Skill.find_by(name: "Ruby")
Opening.second.skills << Skill.find_by(name: "Ruby on Rails")
Opening.second.skills << Skill.find_by(name: "Postgres")

rafi.skills << Skill.find_by(name: "Javascript")
rafi.skills << Skill.find_by(name: "CSS")
puts "done!"
