class Conversion < ActiveRecord::Base
  serialize :quizlet_definitions

  def before_create
    require 'mechanize'
    @agent = WWW::Mechanize.new
    begin
      self.quizlet_definitions = export_quizlet_set
      self.iknow_list_id       = create_iknow_list
      #self.iknow_list_url = "http://#{IKNOW_HOST_WITH_PORT}/#{create_iknow_list}"
    rescue WWW::Mechanize::ResponseCodeError => http_error
      self.errors.add(:quizlet_url, "Could not connect to iKnow API or Quizlet server... (#{http_error.to_s})")
      return false
      #rescue => e
      #  self.errors.add(:quizlet_url, e.to_s + e.backtrace.join('<br/>'))
      #  return false
    end
    true
  end

  private

  def export_quizlet_set
    logger.info("Fetching: #{quizlet_url}")
    page = @agent.get(quizlet_url)

    # Determine id, title and description
    quizlet_id        = /set\/([^\/]+)/.match(quizlet_url)[1]
    title_h2          = page.search(".i3 h2").first.to_s
    self.quizlet_name = /span\>(.+)\</.match(title_h2)[1]
    tags              = page.search('table.allsets tr td em a').collect(&:inner_text)
    self.quizlet_description = tags.join(', ')
    @attribution = {'media_entity' => quizlet_url, 'attribution_license_id' => 7}
    info_table_trs = page.search(".small table.allsets tr")
    info_table_trs.each do |tr|
      tds = tr.search('td')
      next if tds.blank?
      if tds[0].inner_text == 'Creator'
        link = tds.search('a').first
        next unless link
        @attribution['author_url'] = "http://quizlet.com#{link.attributes['href']}"
        @attribution['author'] = link.inner_text
      end
    end
    # Get definition list.
    puts "http://quizlet.com/export/#{quizlet_id}"
    page         = @agent.get("http://quizlet.com/export/#{quizlet_id}/")
    @definitions = {}
    word_data    = page.search('#word-data').first.inner_text
    word_data.split("\n").each do |definition_pair|
      cue, response     = definition_pair.split("\t")
      @definitions[cue] = response
    end

    @definitions
  end

  def create_iknow_list
    list_params = {
      "list[name]"        => self.quizlet_name,
      "list[description]" => self.quizlet_description,
      "list[language]"      => self.cue_language_code || 'en',
      "list[translation_language]" => self.response_language_code || 'ja'
    }
    @attribution.each do |key, value|
      list_params["attribution[#{key}]"] = value
    end
    response = post_to_iknow("/lists", list_params)
    puts [:post_list, response].inspect
    puts response.body

    raise "failure\n#{response.body}" unless response.code.to_i == 201

    list_id = response.body
    create_iknow_list_items(list_id)

    return list_id
  end

  def create_iknow_list_items(list_id)
    @definitions.keys.each do |cue|
      item_param = {
        "cue[text]"                   => cue,
        "cue[language]"      => self.cue_language_code || 'en',
        "response[language]" => self.response_language_code || 'ja',
        "response[text]"              => @definitions[cue],
        "list_id"                     => list_id
      }
      response = post_to_iknow("/items", item_param)
      puts [:post_item, response].inspect

      item_id = response.body
      add_image_to_item(cue, @definitions[cue], list_id, item_id)
      #add_sound_to_item(self.cue_language_code, cue, item_id) # Adding the item autogenerates TTS 
    end
  end

  def add_image_to_item(item_cue_text, item_response_text, list_id, item_id)
    image_url = FlickrGetPhoto.determine_flickr_cue_image(item_cue_text) || FlickrGetPhoto.determine_flickr_cue_image(item_response_text)
    if image_url
      image_param = {
        "image[url]" => image_url,
        "list_id" => list_id
      }
      response = post_to_iknow("/items/#{item_id}/images", image_param)
      puts [:post_image, response].inspect
    else
      puts "image not found"
    end
  end

  def add_sound_to_item(language_code, text, item_id)
    text_to_speech = IknowTextToSpeech.new(language_code)
    sound_url = text_to_speech.text_to_mp3_url(text)
    puts sound_url
    if sound_url
      sound_params = {
        "sound[url]" => sound_url
      }
      response = post_to_iknow("/items/#{item_id}/sounds", sound_params)
      puts [:post_sound, response].inspect
    else
      puts "sound not found"
    end
  end

  def post_to_iknow(path, data)
    #puts [ :post_to_iknow, "http://#{IKNOW_HOST_WITH_PORT}#{path}", data ].inspect
    auth_token.to_access_token.post("http://#{IKNOW_HOST_WITH_PORT}#{path}", data)
  end

  def auth_token
    auth_token ||= Authtoken.find_by_username(self.iknow_username)
    auth_token
  end

end

