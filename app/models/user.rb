class User < ActiveRecord::Base
  include PgSearch

  validates_presence_of :first_name, :last_name, :email, :netid
  validates_uniqueness_of :email, :netid

  has_and_belongs_to_many :leading_projects, class_name: "Project", source: :leaders
  has_and_belongs_to_many :openings
  # has_many :member_projects, through: :openings, source: :members

  has_many :skill_links, as: :skillable, dependent: :destroy
  has_many :skills, through: :skill_links

  has_many :favorites, dependent: :destroy
  has_many :favorite_openings, through: :favorites,
    class_name: "Opening", source: :opening


  has_attached_file :resume
  validates_attachment_content_type :resume, :content_type => "application/pdf"
  validates_attachment_size :resume, :less_than => 5.megabytes

  has_attached_file :picture, styles: { normal: "200x200" },
    default_url: "/assets/default-user.svg"
  validates_attachment_content_type :resume, :content_type => /\Aimage\/.*\Z/
  validates_attachment_size :resume, :less_than => 1.megabytes

  pg_search_scope :basic_search,
    against: [:first_name, :last_name, :email, :netid, :bio],
    using: {tsearch: {dictionary: "english", any_word: true}}

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.search_filtered(users)
    users.select { |u| u.show_in_results }.uniq
  end

  def self.search(search_params, page=0)
    page ||= 0
    query = search_params[:q]
    # TODO: how to match everything? Does postgres search do globbing? ie. *
    matching_openings = basic_search(query) # match by name, desc
    skill_openings = Skill.search(query).map(&:users).flatten
    # TODO: Prioritize those that match by both
    # TODO: Match by projects?
    return User.search_filtered (matching_openings + skill_openings)
  end

  def serializable_hash(options={})
    options = {
      :methods => [:favorite_opening_ids, :full_name],
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
    browser.get("http://directory.yale.edu/phonebook/index.htm?" + 
      "searchString=uid%3D#{netid}")
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
