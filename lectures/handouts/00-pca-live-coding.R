set.seed(12345)
n <- 100L
x_signal <- mvtnorm::rmvnorm(n, c(1, 1), matrix(c(3, 1.5, 1.5, 3), nrow = 2))
plot(x_signal)
x_noise <- matrix(rnorm(n * 8), nrow = n)
x <- cbind(x_signal, x_noise)

# noise free
s0 <- svd(scale(x_signal, TRUE, FALSE))
z0 <- s$u %*% diag(s$d)
par(mfrow = c(1, 2))
plot(x_signal)
plot(z)
s0$v

# manual PCA (full data)
s1 <- svd(scale(x, TRUE, FALSE))
z1 <- s$u[,1:2] %*% diag(s$d[1:2])
par(mfrow = c(1, 2))
plot(x_signal)
plot(z)
s1$v[,1:2]

sdev0 <- s0$d^2 / (2 - 1)
sdev1 <- s1$d^2 / (n - 1) 

par(mfrow = c(1, 2))
plot(sdev0)
plot(sdev1)

# using the function
pca <- prcomp(x)
par(mfrow = c(1, 2))
plot(pca)
plot(sdev1 / sum(sdev1))
par(mfrow = c(1, 1))
biplot(pca)
