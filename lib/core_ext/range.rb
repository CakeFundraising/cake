class Range
  def to_s_with_gsub
    to_s_without_gsub.gsub('..', ' to ')
  end

  def <=>(other)
    [min, max] <=> other.instance_eval { [min, max] }
  end

  alias_method_chain :to_s, :gsub
end