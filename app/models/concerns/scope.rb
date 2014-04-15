module Scope
  extend ActiveSupport::Concern

  # DON'T CHANGE THE ORDER, IF YOU NEED TO ADD JUST APPEND TO THE LIST
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