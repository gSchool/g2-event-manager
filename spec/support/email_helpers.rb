def first_link_in(email_body)
  @document = Nokogiri::HTML(email_body)
  @document.xpath("//html//body//a//@href")[0].value
end