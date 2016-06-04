# Misc. utility methods

# Create directory
makedir <- function(fp) {
    if(!file.exists(fp)) {
        makedir(dirname(fp))
        dir.create(fp)
    }
} 

# Row variance
RowVar <- function(x) {
  rowSums((x - rowMeans(x))^2)/(dim(x)[2] - 1)
}

