# OpenStreetMap South Bay point of interest coverage

This repository contains ingredients for producing a report benchmarking OpenStreetMap’s point of interest coverage in Santa Clara County, California, against public statistics. This report grew out of [an initiative](https://github.com/codeforsanjose/OSM-SouthBay/issues/23) by Code for San José (now Open Source San José) to incorporate the Santa Clara County Public Health Department’s pandemic-era [Social Distancing Protocol (SDP) Business Database](https://sdp.sccgov.org/) into OpenStreetMap.

![OpenStreetMap POI coverage in Santa Clara County by tract](https://user-images.githubusercontent.com/1231218/120296772-4fc5dd80-c27d-11eb-97cc-ca252684eebf.png)
![OpenStreetMap POI coverage in Santa Clara County by ZIP code](https://user-images.githubusercontent.com/1231218/120296787-53596480-c27d-11eb-8941-46899ba7f0d7.png)

[A snapshot of this report from June 2021](https://commons.wikimedia.org/wiki/File:Mapping_points_of_interest_in_Santa_Clara_County_%28Silicon_Valley%29.pdf) is available on Wikimedia Commons.

## System requirements

* Bash
* [Osmium](https://osmcode.org/osmium-tool/)
* [QGIS](https://qgis.org/)

## Assembling the report

The following steps are to the best of my recollection but should hopefully include enough hints to reconstruct the QGIS project:

1. Prepare the geographic areas:
   1. Download the national shapefile of [ZIP Code Tabulation Areas](https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2022&layergroup=ZIP+Code+Tabulation+Areas) and the California shapefile of [census tracts](https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2022&layergroup=Census+Tracts) from the Census Bureau and add both shapefiles to the QGIS project.
   2. Apply the `extractbyattribute` tool in the Processing Toolbox to each layer, one by one, to filter it down to features where `STATEFP` is `06` and `COUNTYFP` is `085`.
2. Prepare the demographic data:
   1. Download tables [ACSDT5Y2021.B02001](https://data.census.gov/table?q=ACSDT5Y2021.B02001&g=050XX00US06085$1400000&tid=ACSDT5Y2021.B02001&tp=true), [ACSDT5Y2021.B03002](https://data.census.gov/table?q=ACSDT5Y2021.B03002&g=050XX00US06085$1400000&tid=ACSDT5Y2021.B03002&tp=true), and [ACSST5Y2021.S1903](https://data.census.gov/table?q=ACSST5Y2021.S1903&g=050XX00US06085$1400000&tid=ACSST5Y2021.S1903&tp=true) from the Census Bureau as CSV files.
   2. Simplify the race and ethnicity data:
      1. Replace `"Census Tract ([\d.]+), Santa Clara County, California",.+?\n"\s+Estimate"` with `"\1"`.
      2. Replace `"\s+Margin of Error".+?\n?` with the empty string.
      3. Replace `(\d),(\d\d\d)` with `\1\2`.
      4. Replace `"(\d+)"` with `\1`.
   3. Simplify the income data:
      1. Replace `"\s+(?:Number|Percent Distribution)".+?\n"\s+Estimate".+?\n"\s+Margin of Error".+?\n` with the empty string.
      2. Replace `"Census Tract ([\d.]+), Santa Clara County, California",.+?\n"\s+Median income \(dollars\)".+?\n"\s+Estimate"` with `"\1"`.
      3. Replace `"\s+Margin of Error".+?\n?` with the empty string.
      4. Replace `(\d),(\d\d\d)` with `\1\2`.
      5. Replace `"(\d+)"` with `\1`.
   5. Add these files to the QGIS project.
   6. Apply the `joinattributestable` tool in the Processing Toolbox to the census tract layer and each of the other demographic layers.
3. Prepare the business activity data:
   1. Download the Complete ZIP Code Totals File from [County Business Patterns 2021](https://www.census.gov/data/datasets/2021/econ/cbp/2021-cbp.html) and unzip the file.
   2. Apply the `joinattributestable` tool in the Processing Toolbox to the ZCTA layer and the CBP layer.
4. Prepare the SDP data:
   1. Download the [MapRoulette challenges](https://github.com/codeforsanjose/OSM-SouthBay/issues/23#issuecomment-729607562) from the SDP import project in GeoJSON format.
   2. Apply the `countpointsinpolygon` tool in the Processing Toolbox to the ZCTA layer and the SDP layer.
   3. Apply the `countpointsinpolygon` tool in the Processing Toolbox to the census tract layer and the SDP layer.
5. Prepare the OSM data:
   1. Download the latest [Northern California](https://download.geofabrik.de/north-america/us/california/norcal.html) extract from Geofabrik as well as one from before the SDP import began on November 27, 2020.
   2. Export [this Overpass query](https://overpass-turbo.eu/s/1yA2) as GeoJSON and name the file santa-clara-county-boundary.geojson.
   3. Run extract-named.sh, passing in the extract’s file name, to filter it down to named POIs in Santa Clara County.
   4. In the QGIS project, add the resulting OSM file to the Sources group (both points and multipolygons).
   5. Apply the `centroids` tool in the Processing Toolbox to the “multipolygons” layer to create a temporary layer of centroids.
   6. Apply the `mergevectorlayers` tool in the Processing Toolbox to the “points” and “multipolygons” layers to create a temporary layer of points and centroids.
   7. Apply the `countpointsinpolygon` tool in the Processing Toolbox to the ZCTA layer and the OSM centroid layer.
   8. Apply the `countpointsinpolygon` tool in the Processing Toolbox to the census tract layer and the OSM centroid layer.
6. For each of the layers added in the previous steps, copy the symbol style from another layer that serves a similar purpose.
7. Edit the symbol size or color expression to reflect the field names you used when applying the `countpointsinpolygon` tool.

## Sources

* [_American Community Survey_](https://www.census.gov/programs-surveys/acs/data.html) (2019). Washington, D.C.: U.S. Census Bureau.
* [_County Business Patterns_](https://www.census.gov/data/datasets/2021/econ/cbp/2021-cbp.html) (2021). Washington, D.C.: U.S. Census Bureau.
* “[Northern California](https://download.geofabrik.de/north-america/us/california/norcal.html)” (2023) [2020]. _OpenStreetMap Data Extracts_. Karlsruhe: Geofabrik.
* [_Social Distancing Protocol Business Database_](https://sdp.sccgov.org/) (2021). San Jose, California: Santa Clara County Public Health Department.
