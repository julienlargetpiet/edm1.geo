![](logo.png)

# Install

-> git clone https://github.com/julienlargetpiet/edm1.geo

-> cd edm1

edm1 > R

R > library("devtools")

R > build()

R > install()

# `geo_min`

geo_min


## Description

Return a dataframe containing the nearest geographical points (row) according to established geographical points (column).


## Usage

```r
geo_min(inpt_datf, established_datf)
```


## Arguments

Argument      |Description
------------- |----------------
`inpt_datf`     |     is the input dataframe of the set of geographical points to be classified, its firts column is for latitude, the second for the longitude and the third, if exists, is for the altitude. Each point is one row.
`established_datf`     |     is the dataframe containing the coordiantes of the established geographical points


## Examples

```r
in_ <- data.frame(c(11, 33, 55), c(113, -143, 167))

in2_ <- data.frame(c(12, 55), c(115, 165))

print(geo_min(inpt_datf=in_, established_datf=in2_))

#         X1       X2
#1   245.266       NA
#2 24200.143       NA
#3        NA 127.7004

in_ <- data.frame(c(51, 23, 55), c(113, -143, 167), c(6, 5, 1))

in2_ <- data.frame(c(12, 55), c(115, 165), c(2, 5))

print(geo_min(inpt_datf=in_, established_datf=in2_))

#        X1       X2
#1       NA 4343.720
#2 26465.63       NA
#3       NA 5825.517
```


# `globe`

globe


## Description

Allow to calculate the distances between a set of geographical points and another established geographical point. If the altitude is not filled, so the result returned won't take in count the altitude.


## Usage

```r
globe(lat_f, long_f, alt_f = NA, lat_n, long_n, alt_n = NA)
```


## Arguments

Argument      |Description
------------- |----------------
`lat_f`     |     is the latitude of the established geographical point
`long_f`     |     is the longitude of the established geographical point
`alt_f`     |     is the altitude of the established geographical point, defaults to NA
`lat_n`     |     is a vector containing the latitude of the set of points
`long_n`     |     is a vector containing the longitude of the set of points
`alt_n`     |     is a vector containing the altitude of the set of points, defaults to NA


## Examples

```r
print(globe(lat_f=23, long_f=112, alt_f=NA, lat_n=c(2, 82), long_n=c(165, -55), alt_n=NA))

#[1] 6342.844 7059.080

print(globe(lat_f=23, long_f=112, alt_f=8, lat_n=c(2, 82), long_n=c(165, -55), alt_n=c(8, -2)))

#[1] 6342.844 7059.087
```


