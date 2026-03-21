---
layout: post
title: Diagnostics and Stationarity
parent: Interview Questions
nav_order: 2
---

# Diagnostics and Stationarity Interview Questions

## Q: What is stationarity, and why does it matter?

**Short interview answer**

A weakly stationary series has time-invariant mean, variance, and autocovariance that depends only on lag, not calendar time. Many classical models assume this because their parameter estimates and forecast equations rely on stable dynamics.

**Core conditions**

```text
E[y_t] = μ
Var(y_t) = σ^2
Cov(y_t, y_(t-k)) = γ_k
```

These should not change with `t`.

## Q: How do you check stationarity?

**What interviewers want**

They usually want more than “I run ADF.” A strong answer combines visual checks, transformations, and two complementary tests.

**Workflow**

1. Plot the series and rolling mean/variance.
2. Inspect ACF and PACF.
3. Apply log transform if variance grows with level.
4. Difference if trend or seasonality is present.
5. Run ADF and KPSS together.

**How to interpret ADF and KPSS**

- ADF null hypothesis: unit root, so the series is non-stationary.
- KPSS null hypothesis: the series is stationary.

**Strong interview line**

If ADF rejects non-stationarity and KPSS fails to reject stationarity, that is strong evidence the transformed series is stationary enough for ARIMA-style modeling.

## Q: What is white noise, and how is it different from stationarity?

**Short interview answer**

White noise is stronger than weak stationarity. A white-noise process has zero autocorrelation at all non-zero lags, while a stationary process may still have serial dependence.

**Core conditions**

```text
E[ε_t] = 0
Var(ε_t) = σ^2
Cov(ε_t, ε_(t-k)) = 0   for k ≠ 0
```

**Why it matters**

After fitting a classical time-series model, I want the residuals to look like white noise. If residual autocorrelation remains, the model has left structure unexplained.

## Q: What residual diagnostics would you run after fitting a forecasting model?

**Strong answer**

- Plot residuals over time.
- Check residual ACF.
- Use Ljung-Box to test joint autocorrelation.
- Inspect residual histogram or Q-Q plot if probabilistic assumptions matter.
- Check whether residual variance changes over time.

**Ljung-Box test idea**

```text
H0: residual autocorrelations up to lag h are jointly zero
```

If the p-value is small, the model likely missed temporal structure.

## Q: Why does differencing help?

**Short interview answer**

Differencing removes low-frequency trend and can convert an integrated process into a stationary one.

**Formula**

```text
First difference:
Δ y_t = y_t - y_(t-1)

Seasonal difference:
Δ_s y_t = y_t - y_(t-s)
```

**What a strong candidate adds**

Over-differencing is harmful because it can inject unnecessary noise and make the series harder to model. I usually choose the smallest differencing order that yields acceptable stationarity and residual behavior.
