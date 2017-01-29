class HomeController < ApplicationController
  def index
    @repository = GitRepository.new(stars: 123, forks: 12, issues: 5)
  end
end
