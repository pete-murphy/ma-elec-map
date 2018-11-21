.PHONY: all clean test

# Download geojson
data/util.geojson:
	@mkdir -p $(dir $@)
	@curl \
		-sS \
		"http://maps-massgis.opendata.arcgis.com/datasets/1710ebf6cf614b5fa97c0a269cece375_0.geojson"
		-o $@.download
	@mv $@.download $@
	