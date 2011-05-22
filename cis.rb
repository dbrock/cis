require "./sass-query"
require "json"

get "/:name.css/cis.js" do
  file_name = "#{params[:name]}.sass"
  content_type "text/javascript", :charset => "utf-8"

  puts settings.sass.inspect

  tree = Sass::Engine.for_file(file_name, settings.sass).to_tree
  json = SassQuery.extract(tree, ["-cis-"]).to_json

  "cis_#{params[:name]} = #{json}"
end
