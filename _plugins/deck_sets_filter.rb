module Jekyll
  module DeckSetsFilter
    def watermark_background(guild)
      "<h1>This is your guild: #{guild}</h1>"
    end

    def mana_symbol(input)
      if input
        mana = input.scan /\{(.*?)\}/
        mana.flatten!
        result = ''
        mana.each do |color|
          color = color.gsub('/', '').downcase
          result += ' <i class="ms ms-cost ms-shadow ms-' + color + '"></i> '
        end

        return result
      end
    end

    def card_set_symbol(input)

      if input
        card_set = input.eql?('gk2') ? 'rna' : input

        '<i class="ss ss-' + card_set + '"></i> '
      end

    end

  end
end

Liquid::Template.register_filter(Jekyll::DeckSetsFilter)
