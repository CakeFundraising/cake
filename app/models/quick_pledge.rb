class QuickPledge < Pledge
  before_create do
    self.status = :accepted
  end
end
