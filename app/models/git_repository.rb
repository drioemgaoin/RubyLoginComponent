class GitRepository
  include ActiveModel::Model

  attr_accessor :stars, :forks, :issues

end
