module TextValidations
  def self.included(base)
    base.validates_format_of :body, :without => /kitten/, :message => "NO KITTEH"
  end
end