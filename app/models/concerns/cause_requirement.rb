module CauseRequirement
  extend ActiveSupport::Concern

  CAUSE_REQUIREMENTS = [:tax_exempt, :donations_in_kind]

  def cause_requirements=(cause_requirements)
    self.cause_requirements_mask = (cause_requirements.map(&:to_sym) & CAUSE_REQUIREMENTS).map { |r| 2**CAUSE_REQUIREMENTS.index(r) }.inject(0, :+)
  end

  def cause_requirements
    CAUSE_REQUIREMENTS.reject do |r|
      ((cause_requirements_mask.to_i || 0) & 2**CAUSE_REQUIREMENTS.index(r)).zero?
    end
  end

  def has_cause_requirement?(cause_requirement)
    cause_requirements.include?(cause_requirement)
  end
end