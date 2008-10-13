
class IknowTextToSpeech
  
  def initialize(language_code)
    @language_code = language_code
  end
  
  def text_to_mp3_url(text)
    require 'mechanize'
    agent = WWW::Mechanize.new
    response = agent.post("http://#{IKNOW_HOST_WITH_PORT}/speeches", :text => text, :language => @language_code)
    response.header['location']
  end
  
end

