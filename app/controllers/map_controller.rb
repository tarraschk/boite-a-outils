class MapController < ApplicationController

  # GET /maps
  def index
    @liste_pays = Comite.where(typecomite: 3, active:true).map { |x| [x.title.split("-", 2)[1].strip!, x.coordinates] }.sort_by{|k,v| k}.uniq { |k, v| k }
    render 'map', :layout => false
  end

  def comitesaj
    results = []
    Comite.where(typecomite: 1, active: true).each do |comite|
      results << {
          "type" => "Feature",
          "properties" => {
              "title" => comite.title,
              "description" => "#{comite.desc1}<br>#{comite.desc2}<br><br><a class=\"btn\" target=\"_parent\" href=\"http://rejoindre.alainjuppe2017.fr/#{comite.slug}\">Rejoindre ce comité</a><style>.btn {\n  background: #3498db;\n  background-image: -webkit-linear-gradient(top, #3498db, #2980b9);\n  background-image: -moz-linear-gradient(top, #3498db, #2980b9);\n  background-image: -ms-linear-gradient(top, #3498db, #2980b9);\n  background-image: -o-linear-gradient(top, #3498db, #2980b9);\n  background-image: linear-gradient(to bottom, #3498db, #2980b9);\n  -webkit-border-radius: 10;\n  -moz-border-radius: 10;\n  border-radius: 10px;\n  font-family: Arial;\n  color: #ffffff !important;\n  font-size: 13px;\n  padding: 5px 10px 5px 10px;\n  text-decoration: none;\n}\n.btn:hover {\n  background: #3cb0fd;\n  background-image: -webkit-linear-gradient(top, #3cb0fd, #3498db);\n  background-image: -moz-linear-gradient(top, #3cb0fd, #3498db);\n  background-image: -ms-linear-gradient(top, #3cb0fd, #3498db);\n  background-image: -o-linear-gradient(top, #3cb0fd, #3498db);\n  background-image: linear-gradient(to bottom, #3cb0fd, #3498db);\n  text-decoration: none;\n}</style>".html_safe,
              "marker-size" => "medium",
              "marker-color" => "#1087bf",
              "marker-symbol" => ""
          },
          "geometry" => {
            "coordinates" => comite.coordinates.split(","),
            "type" => "Point"
          }
      }
    end
    render json: { "type" => "FeatureCollection", "features" => results }
  end

  def comitesjaj
    results = []
    Comite.where(typecomite: 2, active: true).each do |comite|
      results << {
          "type" => "Feature",
          "properties" => {
              "title" => comite.title,
              "description" => "#{comite.desc1}<br>#{comite.desc2}<br><br><a class=\"btn\" target=\"_parent\" href=\"http://rejoindre.alainjuppe2017.fr/#{comite.slug}\">Rejoindre ce comité</a><style>.btn {\n  background: #3498db;\n  background-image: -webkit-linear-gradient(top, #3498db, #2980b9);\n  background-image: -moz-linear-gradient(top, #3498db, #2980b9);\n  background-image: -ms-linear-gradient(top, #3498db, #2980b9);\n  background-image: -o-linear-gradient(top, #3498db, #2980b9);\n  background-image: linear-gradient(to bottom, #3498db, #2980b9);\n  -webkit-border-radius: 10;\n  -moz-border-radius: 10;\n  border-radius: 10px;\n  font-family: Arial;\n  color: #ffffff !important;\n  font-size: 13px;\n  padding: 5px 10px 5px 10px;\n  text-decoration: none;\n}\n.btn:hover {\n  background: #3cb0fd;\n  background-image: -webkit-linear-gradient(top, #3cb0fd, #3498db);\n  background-image: -moz-linear-gradient(top, #3cb0fd, #3498db);\n  background-image: -ms-linear-gradient(top, #3cb0fd, #3498db);\n  background-image: -o-linear-gradient(top, #3cb0fd, #3498db);\n  background-image: linear-gradient(to bottom, #3cb0fd, #3498db);\n  text-decoration: none;\n}</style>".html_safe,
              "marker-size" => "medium",
              "marker-color" => "#f86767",
              "marker-symbol" => ""
          },
          "geometry" => {
              "coordinates" => comite.coordinates.split(","),
              "type" => "Point"
          }
      }
    end
    render json: { "type" => "FeatureCollection", "features" => results }
  end

  def comitesajmonde
    results = []
    Comite.where(typecomite: 3, active: true).each do |comite|
      results << {
          "type" => "Feature",
          "properties" => {
              "title" => comite.title,
              "description" => "#{comite.desc1}<br>#{comite.desc2}<br><br><a class=\"btn\" target=\"_parent\" href=\"http://rejoindre.alainjuppe2017.fr/#{comite.slug}\">Rejoindre ce comité</a><style>.btn {\n  background: #3498db;\n  background-image: -webkit-linear-gradient(top, #3498db, #2980b9);\n  background-image: -moz-linear-gradient(top, #3498db, #2980b9);\n  background-image: -ms-linear-gradient(top, #3498db, #2980b9);\n  background-image: -o-linear-gradient(top, #3498db, #2980b9);\n  background-image: linear-gradient(to bottom, #3498db, #2980b9);\n  -webkit-border-radius: 10;\n  -moz-border-radius: 10;\n  border-radius: 10px;\n  font-family: Arial;\n  color: #ffffff !important;\n  font-size: 13px;\n  padding: 5px 10px 5px 10px;\n  text-decoration: none;\n}\n.btn:hover {\n  background: #3cb0fd;\n  background-image: -webkit-linear-gradient(top, #3cb0fd, #3498db);\n  background-image: -moz-linear-gradient(top, #3cb0fd, #3498db);\n  background-image: -ms-linear-gradient(top, #3cb0fd, #3498db);\n  background-image: -o-linear-gradient(top, #3cb0fd, #3498db);\n  background-image: linear-gradient(to bottom, #3cb0fd, #3498db);\n  text-decoration: none;\n}</style>".html_safe,
              "marker-size" => "medium",
              "marker-color" => "#1087bf",
              "marker-symbol" => ""
          },
          "geometry" => {
              "coordinates" => comite.coordinates.split(","),
              "type" => "Point"
          }
      }
    end
    render json: { "type" => "FeatureCollection", "features" => results }
  end
end
