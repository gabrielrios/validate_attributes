class User
  include ActiveModel::Validations

  attr_accessor :id, :name, :email, :address

  validates_presence_of :name
  validates_length_of   :name, :minimum => 5
  validates_presence_of :email
  validates_presence_of :address

  def self.build(attributes = {})
    new attributes
  end

  def initialize(options = {})
    @new_record = false
    options.each do |key, value|
      send("#{key}=", value)
    end if options
  end

  def attribute_names
    [ "name", "email", "address" ]
  end
end

class Post
  include ActiveModel::Validations
  attr_accessor :id, :title, :content

  validates_presence_of :title, :content

  def self.build(attributes = {})
    new attributes
  end

  def initialize(options = {})
    @new_record = false
    options.each do |key, value|
      send("#{key}=", value)
    end if options
  end

  def attribute_names
    [ "id", "title", "content" ]
  end
end
