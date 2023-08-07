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

1. Download the latest [Northern California](https://download.geofabrik.de/north-america/us/california/norcal.html) extract from Geofabrik as well as one from before the SDP import began on November 27, 2020.
2. Export [this Overpass query](https://overpass-turbo.eu/s/1yA2) as GeoJSON and name the file santa-clara-county-boundary.geojson.
3. Run extract-named.sh, passing in the extract’s file name, to filter it down to named POIs in Santa Clara County.
4. Download tables [ACSDT5Y2019.B02001](https://data.census.gov/table?q=ACSDT5Y2019.B02001&g=050XX00US06085$1400000&tid=ACSDT5Y2019.B02001&tp=true), [ACSDT5Y2019.B03002](https://data.census.gov/table?q=ACSDT5Y2019.B03002&g=050XX00US06085$1400000&tid=ACSDT5Y2019.B03002&tp=true), and [ACSST5Y2019.S1903](https://data.census.gov/table?q=ACSST5Y2019.S1903&g=050XX00US06085$1400000&tid=ACSST5Y2019.S1903&tp=true) from the Census Bureau and unzip the files.
5. Download the Complete ZIP Code Totals File from [County Business Patterns 2021](https://www.census.gov/data/datasets/2021/econ/cbp/2021-cbp.html) and unzip the file.
6. Download the [MapRoulette challenges](https://github.com/codeforsanjose/OSM-SouthBay/issues/23#issuecomment-729607562) from the SDP import project in GeoJSON format.
7. In the QGIS project, replace references to various files under the Sources group with the downloaded files.
8. Reconstruct the derived layers using the `countpointsinpolygon`, `joinattributestable`, `mergevectorlayers`, and `centroids` tools in the Processing Toolbox.

## Sources

* [_American Community Survey_](https://www.census.gov/programs-surveys/acs/data.html) (2019). Washington, D.C.: U.S. Census Bureau.
* [_County Business Patterns_](https://www.census.gov/data/datasets/2021/econ/cbp/2021-cbp.html) (2021). Washington, D.C.: U.S. Census Bureau.
* “[Northern California](https://download.geofabrik.de/north-america/us/california/norcal.html)” (2023) [2020]. _OpenStreetMap Data Extracts_. Karlsruhe: Geofabrik.
* [_Social Distancing Protocol Business Database_](https://sdp.sccgov.org/) (2021). San Jose, California: Santa Clara County Public Health Department.
