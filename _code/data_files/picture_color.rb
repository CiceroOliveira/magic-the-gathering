require 'miro'

Miro.options[:color_count] = 3
colors = Miro::DominantColors.new '../../assets/img/prerelease_pack_azorius.png'
puts colors.to_rgb