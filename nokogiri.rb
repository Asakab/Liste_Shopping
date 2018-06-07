require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'



base = "https://www.timeout.fr/paris/shopping/notre-guide-de-boutiques-mode-femmes"


page = Nokogiri::HTML(open(base))
	
tab = []
tab_hash = []
boutique = page.css("div.row div.feature-item__column")
boutique.each do | coucou |
  boutique.css("h3.xs-text-5.md-text-4.xs-line-height-8.md-line-height-7 a").each do | pipi |
	unless pipi["href"].include?("timeout")
      unless tab.include?(pipi["href"])
        tab << pipi["href"]
      end
    end
  end
end


tab.each_with_index do | part,index |
 url = "https://www.timeout.fr" + part 
 page = Nokogiri::HTML(open(url))
 boutique = page.xpath('/html/body/div[2]/main/article/header/div/div[1]/h1').text
 address = page.css('td:contains("Paris")').text.gsub(" ", "").gsub(/\n/, " ")
 horaire =  page.css('td:contains("Du ")').text
 metro = page.xpath('/html/body/div[2]/main/article/header/div/div[2]/span[2]/span').text.gsub(" ", "").gsub(/\n/, "").split(" ")             
 tab_hash[index] = Hash[:Boutique => boutique, :Addresse => address, :Horaire => horaire, :Metro => metro]
p tab_hash
end


CSV.open('shopz.csv', "wb") do |csv|
      csv << [:Boutique, :Addresse, :Horaire, :Metro] # première ligne
     	 tab_hash.each do |value|
      	 csv << [value[:Boutique], value[:Addresse], value[:Horaire], value[:Metro]]
  		end
  	end

