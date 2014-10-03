ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
end

# Must have name and description fields to use this
RSpec.shared_examples "thoroughly searchable" do
  before(:each) do
    @ios_searchable = create(described_class, name: "iOS Searchable",
    description: "Must have design sense, experience with Swift.")
    @js_searchable = create(described_class, name: "Javascript Searchable",
    description: "For fast-paced, experienced coders.") 
  end

  it "finds when word is in name" do
    expect(described_class.thorough_search("iOS")).to eq [@ios_searchable]
  end

  it "finds when word is in description" do
    expect(described_class.thorough_search("Swift")).to eq [@ios_searchable]
  end

  it "is case insensitive" do
    expect(described_class.thorough_search("swIfT")).to eq [@ios_searchable]
  end

  it "finds description by loose terms" do
    expect(described_class.thorough_search("designing coder")).to match_array(
      [@js_searchable, @ios_searchable])
  end

  it "finds containing any with multiple words" do
    expect(described_class.thorough_search("Javascript Swift")).to match_array(
      [@js_searchable, @ios_searchable])
  end
end
