
library(R.matlab)
library(EnvCpt)
library(patchwork)
library(mcp)

data <- readMat('Rdata.mat')
days <- readMat('days.mat')

y = data$savedata[15,15,1:95,7];

yc = y[complete.cases(y)];
xc = days$days[complete.cases(y)];

df = data.frame(
  x = xc,
  y = yc
)

fit_envcpt = envcpt(df$y)  # Fit all models at once
fit_envcpt$summary  # Show log-likelihoods


plot(fit_envcpt)

fit_envcpt$meancpt@cpts

fit_envcpt$meancpt@param.est

model = list(y~1, 1~1)  # three intercept-only segments
fit_mcp = mcp(model, data = df, par_x = "x")

summary(fit_mcp)


plot(fit_mcp) + plot_pars(fit_mcp, pars = c("cp_1"), type = "dens_overlay")



