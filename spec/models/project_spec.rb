require "rails_helper"

RSpec.describe Project, :type => :model do
  it "requires necessary attributes" do
    expect(build(:project, name: nil)).to_not be_valid
    expect(build(:project, description: nil)).to_not be_valid
  end

  it_behaves_like "thoroughly searchable"

  it "destroys associated openings" do
    project = create(:project)
    o1 = create(:opening, project: project)
    o2 = create(:opening, project: project)
    expect(Project.find_by(id: project.id)).to_not be nil
    expect(Opening.find_by(id: o1.id)).to_not be nil
    expect(Opening.find_by(id: o2.id)).to_not be nil
    project.destroy
    expect(Project.find_by(id: project.id)).to be nil
    expect(Opening.find_by(id: o1.id)).to be nil
    expect(Opening.find_by(id: o2.id)).to be nil
  end
end