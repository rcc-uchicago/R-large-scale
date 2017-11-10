# Create a scatterplot from the two selected columns (x, y) in the
# data frame, "dat".
generate.scatterplot <- function (dat, x, y)
  ggplot(data = dat,mapping = aes_string(x = x,y = y),
         environment = environment()) +
    geom_point(shape = 20,size = 3,color = "black")

# Create a scatterplot from the two selected columns (x, y) in the
# data frame, "dat", and vary shape and color according to column
# z. Column z should be a factor.
scatterplot.vary.shapeandcolor <- function (dat, x, y, z) {
  colors <- c("#E69F00","#56B4E9","#009E73","#F0E442","#0072B2",
              "#D55E00","#CC79A7")
  shapes <- c(19,17,8,1,3)
  n      <- levels(dat[[z]])
  colors <- rep(colors,length.out = n)
  shapes <- rep(shapes,length.ouy = n)
  return(ggplot(data = dat,
                 mapping = aes_string(x = PC1,y = PC2,color = z,shape = z),
                 environment = environment()) +
           geom_point(size = 3) +
           scale_color_manual(values = colors) +
           scale_shape_manual(values = shapes))
}
