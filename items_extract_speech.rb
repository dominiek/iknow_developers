
require 'rubygems'
require 'rexml/document'
require 'mechanize'

agent = WWW::Mechanize.new
page = agent.get("http://wapi.iknow.co.jp/items/extract.xml", :text => ARGV[0])
xml = REXML::Document.new(page.body).root
words = {}
xml.elements.to_a('/vocabulary/items/item').each do |item|
  words[item.elements['cue/text'].text] = item.elements['cue/sound'].text
end
ARGV[0].split(' ').each do |word|
  puts word.upcase
  `mplayer #{words[word]}`
end
