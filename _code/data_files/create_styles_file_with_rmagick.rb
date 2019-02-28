require 'RMagick'

include Magick

# image_name = 'akira-cycle-2.png'
# image_name = 'prerelease_pack_gruul.png'

def image_colors(input_image)
  image = ImageList.new(input_image)

  q = image.resize_to_fit(75, 75).quantize(8, Magick::RGBColorspace)

  palette = q.color_histogram.sort {|a, b| b[1] <=> a[1]}

  # width in px times height in px
  total_depth = image.columns * image.rows

  results = []

  palette.count.times do |i|
    p = palette[i]

    r1 = p[0].red / 256
    g1 = p[0].green / 256
    b1 = p[0].blue / 256

    r2 = r1.to_s(16).rjust(2, "0")
    g2 = g1.to_s(16).rjust(2, "0")
    b2 = b1.to_s(16).rjust(2, "0")

    # r2 += r2 unless r2.length == 2
    # g2 += g2 unless g2.length == 2
    # b2 += b2 unless b2.length == 2

    rgb = "#{r1},#{g1},#{b1}"
    hex = "#{r2}#{g2}#{b2}"
    depth = p[1]

    results << {
      rgb: rgb,
      hex: hex,
      percent: ((depth.to_f / total_depth.to_f) * 100).round(2)
    }
  end

  # q.write('../../assets/img/test/new_' + File.basename(input_image))

  # puts results

  results
end

def background_color_from_image(image_file)
  image = Image.read(image_file).first
  image_file_name = File.basename(image_file, File.extname(image_file))

  image[:Label] = image_file_name
  image_inside = image.clone
  image_inside.resize_to_fit!(image.rows - 10)

  image.composite!(image_inside, CenterGravity, DstOutCompositeOp)

  q = image.quantize(8, Magick::RGBColorspace)

  palette = q.color_histogram.sort {|a, b| b[1] <=> a[1]}

  # width in px times height in px
  total_depth = image.columns * image.rows

  results = []

  palette.count.times do |i|
    p = palette[i]

    r1 = p[0].red / 256
    g1 = p[0].green / 256
    b1 = p[0].blue / 256

    r2 = r1.to_s(16).rjust(2, "0")
    g2 = g1.to_s(16).rjust(2, "0")
    b2 = b1.to_s(16).rjust(2, "0")

    # r2 += r2 unless r2.length == 2
    # g2 += g2 unless g2.length == 2
    # b2 += b2 unless b2.length == 2

    rgb = "#{r1},#{g1},#{b1}"
    hex = "#{r2}#{g2}#{b2}"
    depth = p[1]

    results << {
      rgb: rgb,
      hex: hex,
      percent: ((depth.to_f / total_depth.to_f) * 100).round(2)
    }
  end

  return results[0]
end

color_file = File.new("../../_sass/generated_styles.scss", 'w')

input_files = "../../assets/img/*.{png,jpg}"
# input_files = "../../assets/img/test/*.{png,jpg}"

Dir.glob(input_files).sort.each do |file|
  if file !~ /watermark/
    style = File.basename(file, File.extname(file)).downcase.strip

    background_color = background_color_from_image file
    colors = image_colors(file)

    color_file.puts ".#{style} {"
    # color_file.puts "  color: #{colors[0]};"
    color_file.puts "  color: #eee;"
    color_file.puts "  border-color: ##{colors[2][:hex]};"
    color_file.puts "  background-color: ##{background_color[:hex]};"
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
