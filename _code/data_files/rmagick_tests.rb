require 'RMagick'

include Magick

def image_colors(image)
  q = image.quantize(8, Magick::RGBColorspace)
  # q = image.resize_to_fit(75, 75).quantize(8, Magick::YIQColorspace)

  palette = image.color_histogram.sort {|a, b| b[1] <=> a[1]}

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

  # For troubleshooting
  # q.write('../../assets/img/test/new_' + File.basename(input_image))

  puts results

  results
end

def print_palette(image)
  image_file_name = image[:Label]
  palette = image_colors(image)

  canvas = ImageList.new
  canvas << image.resize_to_fit(250, 250)
  canvas.cur_image[:Label] = image_file_name
  draw = Draw.new
  draw.annotate(canvas.cur_image, 0, 0, 0, 20, image_file_name) {
      self.pointsize = 20
      self.font = 'Helvetica'
      self.fill = "white"
      self.gravity = CenterGravity
  }

  palette.each do |color|

    canvas.new_image(250, 250) do |image|
      image.background_color = "rgb(#{color[:rgb]})"
    end

    draw.annotate(canvas.cur_image, 0, 0, 0, 20, color[:hex]) {
        self.pointsize = 20
        self.font = 'Helvetica'
        self.fill = "white"
        self.gravity = CenterGravity
    }

  end

  canvas.append(false).write('../../assets/img/test/new_' + image_file_name + '.png')
end

# def background_color(image_file)
#   offset = 50
#   image_file_name = File.basename(image_file, File.extname(image_file))
#   border = ImageList.new
#   middle = ImageList.new
#
#   image = ImageList.new(image_file)
#   width = image.columns
#   height = image.rows
#   image.trim!
#   image.shave!(1, 1)
#   image.background_color = 'transparent'
#
#   border << image.crop(0, 0, width, offset, true) #top
#
#   middle << image.crop(0, offset, offset, height - offset - offset, true) #left
#   middle << image.crop(width - offset, offset, offset, height - offset - offset, true) #right
#
#   border << middle.append(false)
#
#   border << image.crop(0, height - offset, width, offset, true) #bottom
#
#   # image.write('../../assets/img/test/new_' + image_file_name + '.png')
#   border.append(true).write('../../assets/img/test/border_' + image_file_name + '.png')
# end

def print_background_palette(image_file)
  image = Image.read(image_file).first
  image_file_name = File.basename(image_file, File.extname(image_file))

  image[:Label] = image_file_name
  image_inside = image.clone
  image_inside.resize_to_fit!(image.rows - 10)

  image.composite!(image_inside, CenterGravity, DstOutCompositeOp)

  print_palette image
end

input_files = "../../assets/img/*azorius*.{png,jpg}"

Dir.glob(input_files).sort.each do |file|
  if file !~ /watermark/
    puts File.basename(file, File.extname(file))
    print_background_palette file
    # background_color file
    # print_palette file
  end
end
