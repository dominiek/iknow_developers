
class FlickrGetPhoto

  def self.determine_flickr_cue_image(text)
    require 'open-uri'
    require 'rexml/document'
    
    # preprocess
    tags = text.gsub(/\(.+\)/, '')
  
    # search complete cue or subset
    tags.downcase!
    image_url = get_flickr_image_for_tags(tags)
    image_url ||= get_flickr_image_for_keywords(tags)
    image_url ||= get_flickr_image_for_tags(tags.gsub(/,.+/, '').strip.gsub(/\s+/, ','))
    return unless image_url
    
    image_url 
  end

  def self.get_flickr_image_for_tags(tag_list)
    query_url = "http://api.flickr.com/services/rest/?page=1&method=flickr.photos.search&api_key=0cefac053db4b59f39c35e3e497c7310&per_page=1&tag_mode=all&tags=#{CGI.escape(tag_list)}&license=4&sort=relevance"
    get_flickr_image_for_query_url(query_url)
  end
  
  def self.get_flickr_image_for_keywords(text)
    query_url = "http://api.flickr.com/services/rest/?page=1&method=flickr.photos.search&api_key=0cefac053db4b59f39c35e3e497c7310&per_page=1&text=#{CGI.escape(text)}&license=4&sort=relevance"
    get_flickr_image_for_query_url(query_url)
  end
  
  def self.get_flickr_image_for_query_url(query_url)
    sleep 1
    search_results_xml = open(query_url).read
    return nil if search_results_xml.blank?
    root = REXML::Document.new(search_results_xml).root
    photo = root.elements['photos/photo']
    return nil if photo.blank?
    "http://farm#{photo.attributes['farm']}.static.flickr.com/#{photo.attributes['server']}/#{photo.attributes['id']}_#{photo.attributes['secret']}_m.jpg"
  end

end
