module CakestersHelper
  def commissions_percentage
    Cakester::COMMISSIONS.map{|v| ["#{v}%", v]}
  end
end
