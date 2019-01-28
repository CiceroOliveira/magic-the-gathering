gem 'redcarpet'
require "redcarpet"

data = File.read("ravnica_allegiance_theme_sets_contents.markdown")

html = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new).render(data)

File.write "ravnica_allegiance_theme_sets_contents.html", html