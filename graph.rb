require "rubygems"
require "neo4j-wrapper"

class Capability
  include Neo4j::NodeMixin
  
  property :name
end

class Engagement
  include Neo4j::NodeMixin
  
  property :name, :index => :exact
  property :client, :index => :exact
  
  has_n(:requirement)
end

class Consultant
  include Neo4j::NodeMixin
  
  property :name, :index => :exact
  
  has_n(:skill)
end

def assignments(consultant, *engagements)
  engagements.each do |engagement|
    consultant.outgoing(:assigned_to) << engagement
  end
end

Neo4j::Transaction.run do
  ba = Capability.new :name => "Business Analysis"
  ssis = Capability.new :name => "SSIS"
  c_sharp = Capability.new :name => "C#"
  tdd = Capability.new :name => "Test Driven Development"
  bdd = tdd
  javascript = Capability.new :name => "JavaScript"
  html = Capability.new :name => "HTML"
  sql = Capability.new :name => "SQL"
  scrum = Capability.new :name => "Scrum"
  git = Capability.new :name => "Git"
  svn = Capability.new :name => "Subversion"
  java = Capability.new :name => "Java"
  hibernate = Capability.new :name => "Hibernate"
  spring = Capability.new :name => "Spring"
  tfs = Capability.new :name => "TFS"
  
  pcol = Engagement.new :name => "PCOL", :client => "Logica"
  pcol.requirement << java << svn << spring << hibernate
  cofunds = Engagement.new :client => "Cofunds"
  proms = Engagement.new :name => "PROMs", :client => "HSC-IC"
  proms.requirement << ssis << sql
  direct_channels = Engagement.new :name => "Direct Channels", :client => "Argus Media"
  direct_channels.requirement << c_sharp << javascript << git
  dashboard = Engagement.new :name => "ICIS Dashboard", :client => "RBI"
  dashboard.requirement << c_sharp << javascript << sql << tfs

  anup = Consultant.new :name => "Anup"
  anup.skill << git << c_sharp << scrum << tfs
  david = Consultant.new :name => "David"
  gary = Consultant.new :name => "Gary"
  gary.skill << java << c_sharp
  james = Consultant.new :name => "James"
  jamie = Consultant.new :name => "Jamie"
  jamie.skill << ssis << sql << svn
  kevin = Consultant.new :name => "Kevin"
  kevin.skill << java << c_sharp << svn << spring << hibernate
  lee = Consultant.new :name => "Lee"
  lee.skill << c_sharp << git
  letitia = Consultant.new :name => "Letitia"
  letitia.skill << ba
  matt = Consultant.new :name => "Matt"
  matt.skill << c_sharp << git
  olly = Consultant.new :name => "Olly"
  ruchira = Consultant.new :name => "Ruchira"
  wamiq = Consultant.new :name => "Wamiq"
  
  assignments(letitia, proms)
  assignments(anup, proms, direct_channels, dashboard)
  assignments(kevin, proms, dashboard)
  assignments(olly, proms, direct_channels, dashboard)
  assignments(wamiq, proms)
  assignments(jamie, proms)
  assignments(lee, direct_channels, cofunds)
  assignments(matt, direct_channels, cofunds)
  assignments(david, direct_channels)
  assignments(gary, direct_channels, pcol)
  assignments(ruchira, pcol)
  assignments(james, pcol)
  
end