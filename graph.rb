require "rubygems"
require "neo4j-wrapper"

ENGAGEMENTS = [
  {:name => "PROMs", :client => "HSC-IC"},
  {:name => "Direct Channels", :client => "Argus Media"},
  {:name => "ICIS Dashboard", :client => "RBI"}
]

class Engagement
  include Neo4j::NodeMixin
  
  property :name, :index => :exact
  property :client, :index => :exact
end

class Consultant
  include Neo4j::NodeMixin
  
  property :name, :index => :exact
  
#  has_n(:assigned_to).to(Engagement)
end

def assignments(consultant_name, *engagements)
  consultant = Consultant.new :name => consultant_name
  engagements.each do |engagement|
    consultant.outgoing(:ASSIGNED_TO) << engagement
  end
end

Neo4j::Transaction.run do
  proms = Engagement.new ENGAGEMENTS[0]
  direct_channels = Engagement.new ENGAGEMENTS[1]
  dashboard = Engagement.new ENGAGEMENTS[2]
  
  assignments("Letitia", proms)
  assignments("Anup", proms, direct_channels, dashboard)
  assignments("Kevin", proms, dashboard)
  assignments("Olly", proms, direct_channels, dashboard)
  assignments("Wamiq", proms)
  assignments("Jamie", proms)
  
end