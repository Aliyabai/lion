mat = read.table("C:/Users/Aliya/Desktop/bai-project/lion/geneflow/D_value.txt",header=T)
mean(mat$south)/sd(mat$south)
mean(mat$india)/sd(mat$india)
mean(mat$east)/sd(mat$east)
summary(mat)
hist(mat$east,breaks=80,main="H3-east (H1-india,H2-south)",xlab="ABBA")
lines(density(mat$east),col="red")
hist(mat$india,breaks=80,main="H3-india (H1-east,H2-south)",xlab="ABBA")
lines(density(mat$india),col="red")
hist(mat$south,breaks=80,main="H3-south(H1-india,H2-east)",xlab="ABBA")
lines(density(mat$south),col="red")

#header <-(0_1_3, 0_1_4, 0_2_3, 0_2_4, 0_3_1, 0_3_2, 0_4_1, 0_4_2, 1_0_3, 1_0_4, 1_3_0, 1_3_5, 1_4_0, 1_4_5, 1_5_3, 1_5_4, 2_0_3, 2_0_4, 2_3_0, 2_3_5, 2_4_0, 2_4_5, 2_5_3, 2_5_4, 3_0_1, 3_0_2, 3_1_0, 3_1_5, 3_2_0, 3_2_5, 3_5_1,3_5_2,4_0_1,4_0_2,4_1_0,4_1_5,4_2_0,4_2_5,4_5_1,4_5_2,5_1_3,5_1_4,5_2_3,5_2_4,5_3_1,5_3_2,5_4_1,5_4_2)

mystats <- function(x, na.omit=FALSE){
	if (na.omit)
	    x <-x[!is.na(x)]
	m <- mean(x)
	s <- sd(x)
	return(c(mean=m, stdev=s))  
}
