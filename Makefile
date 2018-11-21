.PHONY: all clean test

# Download geojson
json/raw.json:
	@mkdir -p $(dir $@)
	@curl \
		-sS \
		"http://maps-massgis.opendata.arcgis.com/datasets/1710ebf6cf614b5fa97c0a269cece375_0.geojson"
		-o $@.download
	@mv $@.download $@


json/ma-projected.json: json/raw.json
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

all: topojson/ma-quantized-topo.json