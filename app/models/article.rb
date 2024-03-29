require 'text_validations'
class Article < ActiveRecord::Base
  include TextValidations
  has_many :comments, dependent: :destroy
  before_save :capitalize_title

  validates_presence_of :title, :body

  attr_accessible :body, :title
  def self.sorted_by(param)
    case param
    when 'title'
      self.order('title')
    when 'word_count'
      # self.all.sort_by(&:word_count).reverse
      self.all.sort_by {|word| word.word_count}.reverse
    when 'published'
      self.order('created_at DESC')
    else
      raise "I don't know how to order by #{param}"
    end
  end
  
  def self.only(n)
    Article.all.sample(n.to_i)
  end
  
  def word_count
    body.split.count
  end
  
  def capitalize_title
    self.title.capitalize!
  end
end
