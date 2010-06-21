module Plugins
  def gh(*args)
    begin
      html = RestClient.get('http://confessions.grouphug.us/random')
    rescue
      say_to_chan 'GH is down. :('
      return
    end

    doc = Hpricot(html.to_s)

    doc.search("//h2[@class='title']")[5].inner_html =~ /(\d+)/
    number = $1
    confession = doc.search("//div[@class='content']")[5].inner_html.strip
    confession.html_to_ascii!

    confession = Sanitize.clean(confession)

    confession.scan(/.{1,350}/).each_with_index do |line, index|
      line = "#{number} - #{line}" if index == 0
      say_to_chan("#{line}")
      sleep 2
    end
  end
end