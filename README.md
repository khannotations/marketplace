# The Yale Projects Board

### A Senior Project by Rafi Khan and Bobby Dresser
###### Fall 2014, Yale University

#### The Yale Projects Board

As Yale tech community continues to grow and become more robust, more and more projects—either those started independently by students or in connection to an academic department—are being created. Often, those project leaders are faced with the challenging problem of finding talented programmers, designers, and engineers to join their teams, and are unsure where to search.  

We want to solve this coordination with an online projects board that allows those looking for programmers, designers, and engineers (“leaders”) to post their ideas online and recruit talent, and give those looking for projects (“members”) a central location to start their search. The goal is to be professional enough that people take themselves and others seriously on the site, but not so seriously that people short on experience are intimidated. This would also present an exciting opportunity to aggregate data about what kinds of projects are being created at Yale, as well as what skills are most desired.   

The Yale Projects Board will be a website that helps the Yale community match talented students with amazing projects. As a start, the project will be targeted specifically for student-initiated projects within the tech community, but will expand to include projects of any kind, as long as they maintain a connection to Yale.

#### Running the Code

The Yale Projects Board runs on Ruby on Rails, with the front-end powered by Angular.js. It uses CAS for login-management. To run the code, first `clone` the repo and `bundle install`. To work with the Paperclip gem, you'll also need ImageMagick and GhostScript on your computer: `brew install imagemagick` and `brew install gs` on Mac with [Homebrew](http://brew.sh).  

Then you need to create the file `config/credentials.yml`. This file contains private information (like your netid and password) that allows the site to communicate with Yale's directory. It should look like the following, with your own credentials:

    cas_username: "eli123"
    cas_password: "mysecretpassword"
    
The file is already git ignored, so it will not be checked into the git repository.

