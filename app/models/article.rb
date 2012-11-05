class Article < ActiveRecord::Base
  has_many :comments, dependent: :destroy

  attr_accessible :body, :title
  
  def self.sorted_by(option)
    case option
    when 'title'
      self.order('title')
    when 'word_count'
      self.all.sort_by(&:word_count)      
    when 'published'
      self.order('created_at')
    when 'limit'
      self.sort_by(&:only)
    else
      self.all
    end
  end
  
  def only(number)
    
  end
  
  def word_count
    body.split.count
  end
end
