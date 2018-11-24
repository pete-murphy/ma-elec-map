const {
  compose,
  equals,
  filter,
  head,
  groupBy,
  groupWith,
  lensPath,
  map,
  prop,
  uniq,
  view
} = require("ramda")
const { readFileSync, writeFileSync } = require("fs")
const { geoConicConformal } = require("d3")

const projection = d =>
  geoConicConformal()
    .parallels([41 + 43 / 60, 42 + 41 / 60])
    .rotate([71 + 30 / 60, 0])
    .fitSize([960, 960], d)

const data = compose(
  JSON.parse,
  readFileSync
)("./topojson-a/ma-quantized-topo.json")

data.objects["ma-utils"].geometries //?

// data.features[1].properties.ELEC_LABEL //?

data.objects["ma-utils"].geometries.map(
  ({ properties: { ELEC_LABEL } }) => ELEC_LABEL
)
//?

// const utils = compose(
//   map(view(lensPath(["properties"]))),
//   view(lensPath(["objects", "ma-utils", "geometries"]))
// )(data) //?

const rateLUT = {
  fitchburg: 0.35795,
  massachusetts: 0.35795,
  nantucket: 0.391,
  nstar: 0.391,
  wmeco: 0.32862
}

Array.prototype.flatMap = function(f) {
  return this.reduce((acc, x) => [...acc, ...f(x)], [])
}

const avg = xs =>
  xs.reduce((acc, x) => acc + x, 0) / xs.length

console.log(JSON.stringify())

// data.objects["ma-utils"].geometries //?

const newData = {
  ...data,
  objects: {
    ...data.objects,
    ["ma-utils"]: {
      ...data.objects["ma-utils"],
      geometries: {
        ...data.objects["ma-utils"].geometries.map(
          geometry => ({
            ...geometry,
            properties: {
              ...geometry.properties,
              RATE: avg(
                geometry.properties.ELEC.split(
                  ", "
                ).flatMap(util =>
                  Object.entries(rateLUT)
                    .map(
                      ([k, v]) =>
                        new RegExp(k, "i").test(util)
                          ? [v]
                          : []
                    )
                    .reduce((acc, x) => acc.concat(x), [])
                )
              )
            }
          })
        )
      }
    }
  }
}

newData.objects["ma-utils"].geometries[1] //?

writeFileSync(
  "./new-topo.json",
  JSON.stringify(newData, null, 2),
  "utf8"
)
