class User
  attr_reader :username, :id

  ROLES = { publisher: "publisher", author: "author" }.freeze

  def initialize(username, role)
    @id = @username = username
    @role = role
  end

  def publisher?
    @role == ROLES[:publisher]
  end

  def author?
    @role == ROLES[:author]
  end
end
