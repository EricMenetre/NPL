#' A function to plot microstates from a Cartool .seg file
#'
#' This function returns a list of plots, one for each condition entered in the fitting or segmentation in Cartool.
#'
#' @param path_.seg Path to the .seg file from Cartool (e.g. "C:/.../my_microstates.seg)
#' @param vline_onset Argument where to specify if the plot should include a vertical line at the onet of the stimulus (where time = 0). Disable this option when working with response aligned data or time in time frames. Default is FALSE.
#' @param time_ms An array describing the time in ms. Default is "none" implying that time in time frames will be taken into account.To create an array of time values in ms, here is an example. Imagine epochs of 155 time frames (downsampled by 4), here could be an array : c(seq(-100, 0, by = 4), seq(5,520, by = 4))
#' @param size_hist The microstates maps are represented by segments present at each time frame. However, depending on the width of the desired plot, there might be spaces between segments. This parameter allows the user to change the width of the segment to cover the entire space. To better understand the purpose of this parameter, try setting it to 0.5 and to 4 and see the difference. Defaut value is 2, it is supposed to be a good compromise.
#' @param palette A string array containing the palette name. See here the different palettes available: https://www.datanovia.com/en/wp-content/uploads/dn-tutorials/ggplot2/figures/0101-rcolorbrewer-palette-rcolorbrewer-palettes-1.png. This argument is helpful when plotting forward and backward maps, avoiding to have the same maps color for forward and backward. Default is "Spectral".
#' @keywords plot microstates Cartool
#' @export

plot_microstates <- function(path_.seg, vline_onset = FALSE, time_ms = "none", size_hist = 2, palette = "Spectral"){
  require(ggplot2)
  require(ggpubr)
  require(RColorBrewer)
  require(readr)
  require(dplyr)
  require(NPL)
  # Importation of the data
  data_ms <- read_seg_file(path_.seg)
  # Offer the possibility to the user to add a column with the time in ms
  if(time_ms != "none"){
    data_ms$time <- time_ms
  }


  # List of plots
  ncol_data <- ncol(data_ms)
  n_conditions <- (ncol_data-1)/5
  plot_list <- list()
  index_col_GFP <- grep("GFP", colnames(data_ms))
  index_col_Seg <- grep("Seg", colnames(data_ms))

  # Creation of the data frame by extracting the relevant information for each plot and plotting according to the parameters entered as argument.
  if(time_ms == "none"){
    for(i in 1:n_conditions){
      time = as.numeric(simplify2array(data_ms[,"time"]))
      GFP = as.numeric(simplify2array(data_ms[,index_col_GFP[i]]))
      Seg = as.factor(simplify2array(data_ms[,index_col_Seg[i]]))
      data_plot <- data.frame(time,GFP, Seg)
      data_plot$Seg[data_plot$Seg == 0] <- NA
      data_plot <- data_plot%>%rename(Maps = Seg,
                         Time = time)
      rm(time, GFP, Seg)
      plot_list[[i]] <- ggplot(data_plot, aes(x = Time, y = GFP))+
        geom_segment(aes(x = Time-0.1, xend = Time+0.1, y = 0, yend = GFP, color = Maps), size = size_hist)+
        geom_area(fill = "gray", alpha = 0.2)+
        geom_line(col = "black", size = 0.8)+
        theme_minimal()+
        labs(y = "GFP amplitude in mv")+
        scale_color_brewer(palette = palette)
    }
  } else{
      if(vline_onset == TRUE){
        for(i in 1:n_conditions){
          time = as.numeric(simplify2array(data_ms[,"time"]))
          GFP = as.numeric(simplify2array(data_ms[,index_col_GFP[i]]))
          Seg = as.factor(simplify2array(data_ms[,index_col_Seg[i]]))
          data_plot <- data.frame(time,GFP, Seg)
          data_plot$Seg[data_plot$Seg == 0] <- NA
          data_plot <- data_plot%>%rename(Maps = Seg,
                                          Time = time)
          rm(time, GFP, Seg)
          plot_list[[i]] <- ggplot(data_plot, aes(x = Time, y = GFP))+
            geom_segment(aes(x = Time-0.1, xend = Time+0.1, y = 0, yend = GFP, color = Maps), size = size_hist)+
            geom_area(fill = "gray", alpha = 0.2)+
            geom_line(col = "black", size = 0.8)+
            geom_vline(xintercept = 0, col = "black", alpha = 0.8, size = 0.7)+
            theme_minimal()+
            labs(y = "GFP amplitude in mv")+
            scale_color_brewer(palette = palette)
        }
        } else if (vline_onset == FALSE) {
          for(i in 1:n_conditions){
            time = as.numeric(simplify2array(data_ms[,"time"]))
            GFP = as.numeric(simplify2array(data_ms[,index_col_GFP[i]]))
            Seg = as.factor(simplify2array(data_ms[,index_col_Seg[i]]))
            data_plot <- data.frame(time,GFP, Seg)
            data_plot$Seg[data_plot$Seg == 0] <- NA
            data_plot <- data_plot%>%rename(Maps = Seg,
                                            Time = time)
            rm(time, GFP, Seg)
            plot_list[[i]] <- ggplot(data_plot, aes(x = Time, y = GFP))+
              geom_segment(aes(x = Time-0.1, xend = Time+0.1, y = 0, yend = GFP, color = Maps), size = size_hist)+
              geom_area(fill = "gray", alpha = 0.2)+
              geom_line(col = "black", size = 0.8)+
              #geom_vline(xintercept = 0, col = "black", alpha = 0.8, size = 0.7)+
              theme_minimal()+
              labs(y = "GFP amplitude in mv")+
              scale_color_brewer(palette = palette)
     }
    }
   }
  #output
  return(plot_list)
}


