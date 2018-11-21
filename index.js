import {
  compose,
  equals,
  filter,
  head,
  groupBy,
  groupWith,
  lensPath,
  map,
  prop,
  view
} from "ramda"
import { readFileSync } from "fs"
import { geoConicConformal } from "d3"

const projection = d =>
  geoConicConformal()
    .parallels([41 + 43 / 60, 42 + 41 / 60])
    .rotate([71 + 30 / 60, 0])
    .fitSize([960, 960], d)

const data = compose(
  JSON.parse,
  readFileSync
)("./data/util.geojson")

data.features[1].properties.ELEC_LABEL //?

data.features.map(
  ({ properties: { ELEC_LABEL } }) => ELEC_LABEL
)
//?

compose(
  map(prop("ELEC_LABEL")),
  map(view(lensPath(["properties"]))),
  prop("features")
)(data) //?

groupBy(view(lensPath(["properties", "ELEC_LABEL"])))(
  data.features
) //?
