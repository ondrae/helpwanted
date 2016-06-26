require 'rails_helper'

RSpec.describe GithubProject, type: :model do

  describe "a new GithubProject" do
    it "it validates" do
      gh = GithubProject.new("https://www.github.com/ondrae/gitcollections")
      puts gh.url
      expect(gh).to be_valid
    end
  end

end
