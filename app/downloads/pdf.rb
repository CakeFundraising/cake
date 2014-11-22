class Pdf
  include Prawn::View

  def initialize(args)
    header
  end
  
  def header
    image "#{Rails.root}/app/assets/images/cake_logo.png", width: 191, height: 39
  end
end