cache "sitemap_snippets_#{@page}_#{Source.visible.count}" do

  xml.urlset(xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9") do
    [ 'about', 'contact', 'sitemap' ].each do |page|
      xml.url do
        xml.loc "http://www.emoticode.net/#{page}.html"
        xml.lastmod '2013-09-01' 
        xml.changefreq("monthly")
        xml.priority(1.0)
      end
    end

    @sources.each do |source|
      xml.url do
        xml.loc source_with_language_url(:language_name => source.language.name, :source_name => source.name)
        xml.lastmod Time.at( source.created_at ).strftime('%F') 
        xml.changefreq("weekly")
        xml.priority(0.8)
      end
    end

  end

end
