
class TextToSpeech

  VOICES = {
    'sv' => 'erik',
    'be' => 'sofie',
    'nl' => 'max',
    'fi' => 'sanna',
    'fr' => 'bruno',
    'ar' => 'salma',
    'de' => 'klaus',
    'it' => 'chiara'
  }
  
  def initialize(language_code)
    @language_code = language_code
  end
  
  def text_to_mp3_url(text)
    voice = VOICES[@language_code]
    return nil unless voice 
    params = {"php_verif"=>"flash", "php_var_string"=>"#{voice}22k[/voix] #{text}", "php_var_nom"=>"whatever.txt"}
    require 'mechanize'
    agent = WWW::Mechanize.new
    ticket = agent.post("http://vaas3.acapela-group.com/Demo_Web/write.php", params).body.split('=')[1]
    "http://vaas3.acapela-group.com/Demo_Web/Sorties/#{ticket}.mp3"
  end
  
end

