def options
  @options ||= Slop.parse(ARGV[1..-1].map { |s| "--#{s}" }) do
    on :q, :faked_qtty_multiplier=,
      'Specify multiplier for amount of faked data. Default: 5', as: Integer, default: 5
    on :cd, :clean_database=,
      'Specifify whether to clean de DB or not. Default: true', default: true
    on :debug, 'Rescue exceptions and lauch pry on error. Default: true', default: true
  end
end

def create(qtty, assoc_or_table)
  Array.new(qtty) do |i|
    obj = assoc_or_table.create!{ |record| yield(record, i) }
  end
rescue ActiveRecord::RecordInvalid => e
  options.debug? ? e.pry : raise(e)
end

def build(qtty, assoc_or_table, opts=nil)
  Array.new(qtty) do |i|
    if opts.present? and opts[:prebuild]
      yield(assoc_or_table, i)
    else
      assoc_or_table.build{ |record| yield(record, i) }
    end
  end
end

def update(collection)
  collection.map.with_index do |e, i|
    yield(e, i)
    e.save!
  end
end

DatabaseCleaner.clean_with :truncation if options[:cd]
ActionMailer::Base.perform_deliveries = false

require_relative 'seeds/fundraisers.rb'
require_relative 'seeds/sponsors.rb'
require_relative 'seeds/campaigns.rb'
require_relative 'seeds/pledges.rb'
require_relative 'seeds/pledge_requests.rb'

ActionMailer::Base.perform_deliveries = true