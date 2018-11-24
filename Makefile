.PHONY: all clean test

# Download geojson
# NOTE: Something is wrong with this GeoJSON
#   --  was only able to fix after dropping it
#   --  into mapshaper :(. Maybe downloading
#   --  Shapefiles and converting with ogr2ogr
#   --  would be better.
json/1710ebf6cf614b5fa97c0a269cece375_0.geojson:
	@mkdir -p $(dir $@)
	@curl \
		"http://maps-massgis.opendata.arcgis.com/datasets/1710ebf6cf614b5fa97c0a269cece375_0.geojson" \
		-o $@.download
	@mv $@.download $@


json/ma-projected.json: json/1710ebf6cf614b5fa97c0a269cece375_0.geojson
	@geoproject "d3.geoConicConformal().parallels([41 + 43 / 60, 42 + 41 / 60]).rotate([71 + 30 / 60, 0]).fitSize([960, 960], d)" \
		$< \
		> $@

topojson/ma-topo.json: json/ma-projected.json
	@mkdir -p $(dir $@)
	@geo2topo \
		$< \
		> $@

topojson/ma-simple-topo.json: topojson/ma-topo.json
	@toposimplify -p 1 -f \
		< $< \
		> $@

topojson/ma-quantized-topo.json: topojson/ma-simple-topo.json
	@topoquantize 1e5 \
		< $< \
		> $@

topojson/ma-quantized-geo.json: topojson/ma-quantized-topo.json
	@topo2geo \
		ma-projected=$@ \
		< $<

all: topojson/ma-quantized-geo.json

clean: 
	@rm -rf topojson