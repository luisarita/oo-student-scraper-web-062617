require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    students_div = doc.css(".student-card")
    students_div.map do |card|
      {
        :name => card.css(".student-name")[0].text, 
        :location => card.css(".student-location")[0].text,
        :profile_url => card.css("a")[0].attributes["href"].value
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    profile = {
      :profile_quote => "", 
      :bio => ""
    }

    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    social_urls = doc.css(".social-icon-container").css("a")
    social_urls.map do |a|
        url = a.attributes["href"].value
        if /https\:\/\/twitter.com\/[a-t]+/.match(url)
          key = :twitter
        elsif /https\:\/\/www.linkedin.com\/[a-t]+/.match(url)
          key = :linkedin
        elsif /https\:\/\/github.com\/[a-t]+/.match(url)
          key = :github
        else
          key = :blog
        end
        profile[key] = url
    end
    profile[:profile_quote] = doc.css(".profile-quote").text
    profile[:bio] = doc.css(".description-holder").css("p")[0].text
    
    profile
  end

end

