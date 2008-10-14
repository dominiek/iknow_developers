
require 'rubygems'
require 'mechanize'

agent = WWW::Mechanize.new

# Authenticate with simple HTTP Auth
agent.auth('dominiek', 'iloveruby')

# Create a new list
begin
response = agent.post("http://api.iknow.co.jp/lists", 
  'list[name]' => "Automatically Generated Study List", 
  'list[language]' => 'ja', 
  'list[translation_language]' => 'en')
rescue => e
  puts "error: #{e.page.body}"
end

puts "List successfully created!"
