expect_that(helper.function(), equals(2))



png(filename="test2.png")
ggplot(data = diamonds, aes(x = carat, y = price, colour = clarity)) + 
  geom_point()  + 
  geom_smooth() 

dev.off()
?png