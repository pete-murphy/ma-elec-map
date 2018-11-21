import { compose, filter, head } from "ramda"
import { readFileSync } from "fs"

const data = compose(
  JSON.parse,
  readFileSync
)("./data/util.geojson")
