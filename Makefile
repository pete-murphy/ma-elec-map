.PHONY: all clean test

# Download geojson
json/ma-utils.geojson:
	@mkdir -p $(dir $@)
	@curl \
		"http://maps-massgis.opendata.arcgis.com/datasets/1710ebf6cf614b5fa97c0a269cece375_0.geojson" \
		-o $@.download
	@mv $@.download $@


topojson/ma-topo.json: json/ma-utils.geojson
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
		ma-utils=$@ \
		< $<

all: topojson/ma-quantized-geo.json

clean: 
	@rm -rf json
	@rm -rf topojson