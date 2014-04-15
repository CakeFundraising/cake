module Scope
  extend ActiveSupport::Concern

  SCOPES = %w{Global National Regional Local}

  def scopes=(scopes)
    self.scopes_mask = (scopes & SCOPES).map { |r| 2**SCOPES.index(r) }.inject(0, :+)
  end

  def scopes
    SCOPES.reject do |r|
      ((scopes_mask.to_i || 0) & 2**SCOPES.index(r)).zero?
    end
  end

  def has_scope?(scope)
    scopes.include?(scope)
  end
end