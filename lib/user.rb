class User
  attr_reader :username

  ROLES = { publisher: "publisher", author: "author" }.freeze

  def initialize(username, role)
    @username = username
    @role = role
  end

  def publisher?
    @role == ROLES[:publisher]
  end

  def author?
    @role == ROLES[:author]
  end
end
