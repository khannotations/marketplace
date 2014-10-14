# Must have name and description fields to use this
shared_examples "thoroughly searchable" do
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
