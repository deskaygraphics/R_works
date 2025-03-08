example <- 123

example_data <- data.frame(
  ID = 1:10,
  Age = sample(18:65, 10, replace = TRUE),
  Score = round(runif(10, 0, 100), 2)
)

print(example_data)

hist(example_data$Age,
    main = "Histogram of Age", 
    xlab = "Age",
    ylab = "Frequency",
    col = "lightblue",
    border = "black"
)
