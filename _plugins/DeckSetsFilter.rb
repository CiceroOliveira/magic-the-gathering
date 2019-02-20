module Jekyll
  module DeckSetsFilter
    def watermark_background(guild)
      "<h1>This is your guild: #{guild}</h1>"
    end
  end
end

Liquid::Template.register_filter(Jekyll::DeckSetsFilter)
