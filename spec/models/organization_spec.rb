require 'rails_helper'

RSpec.describe Organization, type: :model do

  let(:organization) { create :organization }

  describe "validations" do
    it "can only have one of the same organizations per collection" do
      duplicate_organization = Organization.create(url: organization.url, collection: organization.collection)
      expect(duplicate_organization).to_not be_valid

      organization_new_url = Organization.create(url: "https://github.com/differenturl", collection: organization.collection)
      expect(organization_new_url).to be_valid
    end
  end

  describe "#delete" do
    before do
      3.times do
        create :issue, organization: organization
      end
    end
  end
end
