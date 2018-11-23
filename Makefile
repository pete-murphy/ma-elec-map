.PHONY: all clean test

# Download geojson
json/ma-utils.geojson:
	@mkdir -p $(dir $@)
	@curl \
		"http://maps-massgis.opendata.arcgis.com/datasets/1710ebf6cf614b5fa97c0a269cece375_0.geojson" \
		-o $@.download
	@mv $@.download $@


topojson-a/ma-topo.json: json/ma-utils.geojson
	@mkdir -p $(dir $@)
	@geo2topo \
		$< \
		> $@

topojson-a/ma-simple-topo.json: topojson-a/ma-topo.json
	@toposimplify -s 1e-	8 -f \
		< $< \
		> $@

topojson-a/ma-quantized-topo.json: topojson-a/ma-simple-topo.json
	@topoquantize 1e5 \
		< $< \
		> $@

topojson-a/ma-quantized-geo.json: topojson-a/ma-quantized-topo.json
	@topo2geo \
		ma-utils=$@ \
		< $<

all: topojson-a/ma-quantized-geo.json

clean: 
	@rm -rf topojson-a