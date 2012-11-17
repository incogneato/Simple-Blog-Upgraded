class Comment < ActiveRecord::Base
  include TextValidations
  belongs_to :article
  validates :body, :presence => true,
 	 								 :length => { :maximum => 250 }
  validates_associated :article
  validate :kitten_hater
  attr_accessible :body

end