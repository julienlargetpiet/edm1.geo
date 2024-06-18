#' globe
#'
#' Allow to calculate the distances between a set of geographical points and another established geographical point. If the altitude is not filled, so the result returned won't take in count the altitude.
#' @param lat_f is the latitude of the established geographical point
#' @param long_f is the longitude of the established geographical point
#' @param alt_f is the altitude of the established geographical point, defaults to NA
#' @param lat_n is a vector containing the latitude of the set of points
#' @param long_n is a vector containing the longitude of the set of points
#' @param alt_n is a vector containing the altitude of the set of points, defaults to NA
#' @examples
#' 
#' print(globe(lat_f=23, long_f=112, alt_f=NA, lat_n=c(2, 82), long_n=c(165, -55), alt_n=NA)) 
#'
#' #[1] 6342.844 7059.080
#'
#' print(globe(lat_f=23, long_f=112, alt_f=8, lat_n=c(2, 82), long_n=c(165, -55), alt_n=c(8, -2)))
#'
#' #[1] 6342.844 7059.087
#'
#' @export

globe <- function(lat_f, long_f, alt_f=NA, lat_n, long_n, alt_n=NA){

        rtn_l <- c()

        for (i in 1:length(lat_n)){

               sin_comp <- abs(sin(pi * ((lat_n[i] + 90) / 180)))

               if (abs(long_f - long_n[i]) != 0){

                       delta_long <- (40075 / (360 / abs(long_f - long_n[i]))) * sin_comp

               }else{

                       delat_long <- 0

               }

               if (abs(lat_f - lat_n[i]) != 0){

                        delta_lat <- 20037.5 / (180 / abs(lat_f - lat_n[i]))

               }else{

                        delta_lat <- 0

               }

               delta_f <- (delta_lat ** 2 + delta_long ** 2) ** 0.5

               if (is.na(alt_n[i]) == FALSE & is.na(alt_f) == FALSE){

                        delta_f <- ((alt_n[i] - alt_f) ** 2 + delta_f ** 2) ** 0.5

               }

               rtn_l <- append(rtn_l, delta_f, after=length(rtn_l))

        }

        return(rtn_l)

}

#' geo_min
#' 
#' Return a dataframe containing the nearest geographical points (row) according to established geographical points (column).
#' @param inpt_datf is the input dataframe of the set of geographical points to be classified, its firts column is for latitude, the second for the longitude and the third, if exists, is for the altitude. Each point is one row.
#' @param established_datf is the dataframe containing the coordiantes of the established geographical points
#' @examples
#' 
#' in_ <- data.frame(c(11, 33, 55), c(113, -143, 167))
#' 
#' in2_ <- data.frame(c(12, 55), c(115, 165))
#' 
#' print(geo_min(inpt_datf=in_, established_datf=in2_))
#'
#' #         X1       X2
#' #1   245.266       NA
#' #2 24200.143       NA
#' #3        NA 127.7004
#' 
#' in_ <- data.frame(c(51, 23, 55), c(113, -143, 167), c(6, 5, 1))
#' 
#' in2_ <- data.frame(c(12, 55), c(115, 165), c(2, 5))
#' 
#' print(geo_min(inpt_datf=in_, established_datf=in2_))
#'
#' #        X1       X2
#' #1       NA 4343.720
#' #2 26465.63       NA
#' #3       NA 5825.517
#' 
#' @export

geo_min <- function(inpt_datf, established_datf){

       globe <- function(lat_f, long_f, alt_f=NA, lat_n, long_n, alt_n=NA){

               sin_comp <- abs(sin(pi * ((lat_n + 90) / 180)))

               if (abs(long_f - long_n) != 0){

                       delta_long <- (40075 / (360 / abs(long_f - long_n))) * sin_comp

               }else{

                       delat_long <- 0

               }

               if (abs(lat_f - lat_n) != 0){

                        delta_lat <- 20037.5 / (180 / abs(lat_f - lat_n))

               }else{

                        delta_lat <- 0

               }

               delta_f <- (delta_lat ** 2 + delta_long ** 2) ** 0.5

               if (is.na(alt_n) == FALSE & is.na(alt_f) == FALSE){

                        delta_f <- ((alt_n - alt_f) ** 2 + delta_f ** 2) ** 0.5

               }

               return(delta_f)

       }

      flag_delta_l <- c()

      rtn_datf <- data.frame(matrix(nrow=nrow(inpt_datf), ncol=nrow(established_datf)))

      if (ncol(inpt_datf) == 3){

              for (i in 1:nrow(inpt_datf)){

                      flag_delta_l <- c(flag_delta_l, globe(lat_f=established_datf[1, 1], long_f=established_datf[1, 2], alt_f=established_datf[1, 3], lat_n=inpt_datf[i, 1], long_n=inpt_datf[i, 2], alt_n=inpt_datf[i, 3]))

              }

              rtn_datf[,1] <- flag_delta_l

              if (nrow(established_datf) > 1){

                      for (I in 2:nrow(established_datf)){

                               for (i in 1:nrow(inpt_datf)){

                                        idx <- which(is.na(rtn_datf[i,]) == FALSE)

                                        res <- globe(lat_f=established_datf[I, 1], long_f=established_datf[I, 2], alt_f=established_datf[I, 3], lat_n=inpt_datf[i, 1], long_n=inpt_datf[i, 2], alt_n=inpt_datf[i, 3])

                                        if (rtn_datf[i, 1:(I-1)][idx] > res){

                                               rtn_datf[i, I] <- rtn_datf[i, idx] 

                                               rtn_datf[i, idx] <- NA 

                                        }

                                }

                        }

              }

      }else{

              for (i in 1:nrow(inpt_datf)){

                      flag_delta_l <- c(flag_delta_l, globe(lat_f=established_datf[1, 1], long_f=established_datf[1, 2], lat_n=inpt_datf[i, 1], long_n=inpt_datf[i, 2]))

              }

              rtn_datf[,1] <- flag_delta_l

              if (nrow(established_datf) > 1){

                      for (I in 2:nrow(established_datf)){

                               for (i in 1:nrow(inpt_datf)){

                                        idx <- which(is.na(rtn_datf[i,]) == FALSE)

                                        res <- globe(lat_f=established_datf[I, 1], long_f=established_datf[I, 2], lat_n=inpt_datf[i, 1], long_n=inpt_datf[i, 2])

                                        if (rtn_datf[i, 1:(I-1)][idx] > res){

                                               rtn_datf[i, I] <- res 

                                               rtn_datf[i, idx] <- NA 

                                        }

                               }

                        }

              }

      }

      return(rtn_datf)

}

