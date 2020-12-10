#' A function to plot microstates from a Cartool .seg file
#'
#' This function returns a list of plots, one for each condition entered in the fitting or segmentation in Cartool.
#'
#' @param path_.seg Path to the .seg file from Cartool (e.g. "C:/.../my_microstates.seg)
#' @param vline_onset Argument where to specify if the plot should include a vertical line at the onet of the stimulus (where time = 0). Disable this option when working with response aligned data or time in time frames. Default is FALSE.
#' @param time_ms An array describing the time in ms. Default is "none" implying that time in time frames will be taken into account.To create an array of time values in ms, here is an example. Imagine epochs of 155 time frames (downsampled by 4), here could be an array : c(seq(-100, 0, by = 4), seq(5,520, by = 4))
#' @param size_hist The microstates maps are represented by segments present at each time frame. However, depending on the width of the desired plot, there might be spaces between segments. This parameter allows the user to change the width of the segment to cover the entire space. To better understand the purpose of this parameter, try setting it to 0.5 and to 4 and see the difference. Defaut value is 2, it is supposed to be a good compromise.
#' @param palette A string array containing the color names to include in the plot. Across all plots, maps number will have the same colors. by default the color palette is default, another possibility is to set it on "alternative". This option will use different colors  The color can be customized by indicating the path to an Excel file containing new color names. The first column should contain the maps numbers and the second column the color names.
#' @keywords plot microstates Cartool
#' @export

plot_microstates <- function(path_.seg, vline_onset = FALSE, time_ms = "none", size_hist = 2, palette = "default", scale = "automatic"){
  require(ggplot2)
  require(ggpubr)
  require(RColorBrewer)
  require(readr)
  require(dplyr)
  require(NPL)
  require(readxl)

  # Importation of the data
  data_ms <- read_seg_file(path_.seg)
  # Offer the possibility to the user to add a column with the time in ms
  if(time_ms != "none"){
    data_ms$time <- time_ms
  }

  # Definition of the colors
  if (palette == "default"){
    maps_numbers <- 1:40
    colors <- c("darkgreen",      "coral1",
                "cornflowerblue",  "chartreuse3",
                "cyan4",           "dodgerblue3",
                "firebrick3",      "forestgreen",
                "darkorange2",     "darkorchid",
                "darkred",         "darkseagreen2",
                "darkslategray2",  "deeppink3",
                "gold2",           "darkolivegreen2",
                "darkmagenta",     "deepskyblue2",
                "aquamarine3",     "burlywood4",
                "cadetblue4",      "blue3",
                "darkslateblue",   "gray54",
                "lightblue2",      "lightgoldenrod2",
                "lightsalmon2",    "mediumpurple2",
                "navyblue",        "magenta3",
                "steelblue2",      "tan2",
                "yellowgreen",     "turquoise4",
                "royalblue2",      "red4",
                "lightsteelblue2", "plum4",
                "mediumvioletred", "mediumseagreen")

    color_reference <- data.frame(maps_numbers, colors)
    color_reference$colors <- as.character(color_reference$colors)
    color_reference$maps_numbers <- as.character(color_reference$maps_numbers)
  } else if(palette == "alternative"){
    maps_numbers <- 40:1
    colors <- c("darkgreen",      "coral1",
                "cornflowerblue",  "chartreuse3",
                "cyan4",           "dodgerblue3",
                "firebrick3",      "forestgreen",
                "darkorange2",     "darkorchid",
                "darkred",         "darkseagreen2",
                "darkslategray2",  "deeppink3",
                "gold2",           "darkolivegreen2",
                "darkmagenta",     "deepskyblue2",
                "aquamarine3",     "burlywood4",
                "cadetblue4",      "blue3",
                "darkslateblue",   "gray54",
                "lightblue2",      "lightgoldenrod2",
                "lightsalmon2",    "mediumpurple2",
                "navyblue",        "magenta3",
                "steelblue2",      "tan2",
                "yellowgreen",     "turquoise4",
                "royalblue2",      "red4",
                "lightsteelblue2", "plum4",
                "mediumvioletred", "mediumseagreen")

    color_reference <- data.frame(maps_numbers, colors)
    color_reference$colors <- as.character(color_reference$colors)
    color_reference$maps_numbers <- as.character(color_reference$maps_numbers)

  } else {
    color_reference <- read_excel(palette)
    names(color_reference)[1] <- "maps_numbers"
    names(color_reference)[2] <- "colors"
    color_reference$colors <- as.character(color_reference$colors)
    color_reference$maps_numbers <- as.character(color_reference$maps_numbers)
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
      maps <- distinct(data_plot, Maps)
      maps <- maps%>%filter(!is.na(Maps))%>%arrange(Maps)
      maps$Maps <- as.character(maps$Maps)
      palette <- maps%>%left_join(color_reference, by = c("Maps" = "maps_numbers"))%>%select(colors)
      palette <- palette$colors
      plot_list[[i]] <- ggplot(data_plot, aes(x = Time, y = GFP))+
        geom_segment(aes(x = Time-0.1, xend = Time+0.1, y = 0, yend = GFP, color = Maps), size = size_hist)+
        geom_area(fill = "gray", alpha = 0.2)+
        geom_line(col = "black", size = 0.8)+
        theme_minimal()+
        labs(y = expression(paste("Amplitude in ", mu,"V", sep = "")))+
        theme(axis.text = element_text(size = 12), axis.title = element_text(size = 12))+
        scale_color_manual(values=palette)
      if(is.double(scale)){
        plot_list[[i]] <- plot_list[[i]]+scale_y_continuous(limits = scale)
      }
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
        maps <- distinct(data_plot, Maps)
        maps <- maps%>%filter(!is.na(Maps))%>%arrange(Maps)
        maps$Maps <- as.character(maps$Maps)
        palette <- maps%>%left_join(color_reference, by = c("Maps" = "maps_numbers"))%>%select(colors)
        palette <- palette$colors

        plot_list[[i]] <- ggplot(data_plot, aes(x = Time, y = GFP))+
          geom_segment(aes(x = Time-0.1, xend = Time+0.1, y = 0, yend = GFP, color = Maps), size = size_hist)+
          geom_area(fill = "gray", alpha = 0.2)+
          geom_line(col = "black", size = 0.8)+
          geom_vline(xintercept = 0, col = "black", alpha = 0.8, size = 0.7)+
          theme_minimal()+
          labs(y = expression(paste("Amplitude in ", mu,"V", sep = "")))+
          theme(axis.text = element_text(size = 12), axis.title = element_text(size = 12))+
          scale_color_manual(values=palette)
        rm(data_plot, maps, palette)
        if(is.double(scale)){
          plot_list[[i]] <- plot_list[[i]]+scale_y_continuous(limits = scale)
        }
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
        maps <- distinct(data_plot, Maps)
        maps <- maps%>%filter(!is.na(Maps))%>%arrange(Maps)
        maps$Maps <- as.character(maps$Maps)
        palette <- maps%>%left_join(color_reference, by = c("Maps" = "maps_numbers"))%>%select(colors)
        palette <- palette$colors

        plot_list[[i]] <- ggplot(data_plot, aes(x = Time, y = GFP))+
          geom_segment(aes(x = Time-0.1, xend = Time+0.1, y = 0, yend = GFP, color = Maps), size = size_hist)+
          geom_area(fill = "gray", alpha = 0.2)+
          geom_line(col = "black", size = 0.8)+
          #geom_vline(xintercept = 0, col = "black", alpha = 0.8, size = 0.7)+
          theme_minimal()+
          labs(y = expression(paste("Amplitude in ", mu,"v", sep = "")))+
          theme(axis.text = element_text(size = 12), axis.title = element_text(size = 12))+
          scale_color_manual(values=palette)
        if(is.double(scale)){
          plot_list[[i]] <- plot_list[[i]]+scale_y_continuous(limits = scale)
        }
      }
    }
  }
  #output
  return(plot_list)
}



