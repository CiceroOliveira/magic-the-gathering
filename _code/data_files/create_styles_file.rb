require 'miro'

# Miro.options[:color_count] = 3
# colors = Miro::DominantColors.new '../../assets/img/prerelease_pack_azorius.png'
# puts colors.to_hex

# Dir.entries('../../assets/img').select do |file|
#   puts file
# end

color_file = File.new("../../_sass/generated_styles.scss", 'w')

Dir.glob("../../assets/img/*.{png,jpg}").sort.each do |file|
  # puts file
  if file !~ /watermark/
    style = File.basename(file, File.extname(file)).downcase.strip

    colors = Miro::DominantColors.new(file).to_hex

    color_file.puts ".#{style} {"
    # color_file.puts "  color: #{colors[0]};"
    color_file.puts "  color: #eee;"
    color_file.puts "  border-color: #{colors[1]};"
    color_file.puts "  background-color: #{colors[2]};"
    color_file.puts "}"
    color_file.puts ""
  end
end

Dir.glob("../../assets/img/*watermark.{png,jpg}").sort.each do |file|
  color_file.puts ".#{File.basename(file, '.' + file.split('.').last)}_background {"
  color_file.puts "  background-image: url(\"img/" + file + '");'
  color_file.puts '  background-position: center;'
  color_file.puts '  background-repeat: no-repeat;'
  color_file.puts "}"
  color_file.puts ""
end
