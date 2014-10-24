class User < ActiveRecord::Base
  include PgSearch

  validates_presence_of :first_name, :last_name, :email, :netid
  validates_uniqueness_of :email, :netid

  has_and_belongs_to_many :leading_projects, class_name: "Project", source: :leaders
  has_and_belongs_to_many :openings
  has_many :member_projects, through: :openings, source: :members

  has_many :skill_links, as: :skillable, dependent: :destroy
  has_many :skills, through: :skill_links

  has_attached_file :resume
  validates_attachment_content_type :resume, :content_type => "application/pdf"
  validates_attachment_size :resume, :less_than => 5.megabytes

  def serializable_hash(options={})
    options = {
      :except => [:created_at, :updated_at]
    }.update(options)
    super(options)
  end

  # Gets user information from Yale directory
  def User.get_info netid
    name_regex = /^\s*Name:\s*$/i
    email_regex = /^\s*Email Address:\s*$/i
    college_regex = /^\s*Residential College Name:\s*$/i
    known_as_regex = /^\s*Known As:\s*$/i
    division_regex = /^\s*Division:\s*$/i
    title_regex = /^\s*Title:\s*$/i
    year_regex = /^\s*Class Year:\s*$/i
    browser = User.make_cas_browser
    browser.get("http://directory.yale.edu/phonebook/index.htm?searchString=uid%3D#{netid}")
    logger.debug "\n\nFetching info for #{netid} from Yale directory..."
    user = User.find_or_create_by(netid: netid)
    browser.page.search('tr').each do |tr|
      field = tr.at('th').text
      value = tr.at('td').text.strip
      case field
      when name_regex
        names = value.split(" ")
        user.first_name = names.first
        user.last_name = names.last
      when email_regex
        user.email = value
      when college_regex
        user.college = value
      when known_as_regex
        user.first_name = value
      when division_regex
        user.division = value
      when title_regex
        user.title = value
      when year_regex
        user.year = value
      end
    end
    user.save
    logger.debug "Done fetching!\n\n"
    user
  end

  # Creates a CAS authenticated browser that can access the Yale directory
  def User.make_cas_browser
    browser = Mechanize.new
    browser.get( 'https://secure.its.yale.edu/cas/login' )
    form = browser.page.forms.first
    form.username = ENV['CAS_NETID']
    form.password = ENV['CAS_PASS']
    form.submit
    browser
  end
end
