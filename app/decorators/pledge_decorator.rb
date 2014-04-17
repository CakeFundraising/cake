class PledgeDecorator < ApplicationDecorator
  delegate_all
  decorates_association :campaign
end
