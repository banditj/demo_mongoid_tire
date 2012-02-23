class User
  include Mongoid::Document
  include Tire::Model::Search
  include Tire::Model::Callbacks

  field :snumber,         :type => Integer
  field :age,             :type => Integer
  field :income,          :type => Float

  field :lname,           :type => String
  field :fname,           :type => String
  field :username,        :type => String

  field :birthday,        :type=>Date

  index :snumber, :unique=> true
  index :username, :unique=> true

  #validates_numericality_of :snumber, :age, :income

    # get all products if search from elasticsearch else from db with pagination
  def self.get_users(search_str=nil, page=nil, per=nil)
    per||=Kaminari.config.default_per_page
    if search_str && search_str.length >= 2
      tire.search search_str, :per_page => per, :page => page
    else
      only(:username, :snumber, :fname, :lname).page(page).per(per)
    end
  end

  # elastic search
  index_name 'users'
  def to_indexed_json
    self.to_json
  end

  # for elasticsearch
  def self.paginate(options = {})
    page(options[:page]).per(options[:per_page])
  end

end
