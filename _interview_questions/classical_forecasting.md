---
layout: post
title: Classical Forecasting
parent: Interview Questions
nav_order: 1
---

# Classical Forecasting Interview Questions

## Q: Explain AR, MA, and ARMA models. How do you determine the orders?

**Short interview answer**

An AR model regresses the current value on past values, an MA model regresses the current value on past shocks, and ARMA combines both. For a stationary series, I typically inspect ACF and PACF, fit a few candidate orders, and compare AIC, BIC, and residual diagnostics.

**Core formulas**

```text
AR(p):    y_t = c + φ_1 y_(t-1) + ... + φ_p y_(t-p) + ε_t

MA(q):    y_t = μ + ε_t + θ_1 ε_(t-1) + ... + θ_q ε_(t-q)

ARMA(p,q):
          y_t = c + φ_1 y_(t-1) + ... + φ_p y_(t-p)
                + ε_t + θ_1 ε_(t-1) + ... + θ_q ε_(t-q)
```

**How to identify order**

- For a pure `AR(p)`, the PACF tends to cut off after lag `p` while the ACF tails off.
- For a pure `MA(q)`, the ACF tends to cut off after lag `q` while the PACF tails off.
- For mixed ARMA behavior, both ACF and PACF may tail off, so I fit several candidates and compare information criteria.

**What a strong candidate says next**

- Stationarity is required for ARMA.
- Residuals should look like white noise after fitting.
- Order selection should combine plots, information criteria, and out-of-sample validation.

## Q: What is the difference between ARIMA and SARIMA?

**Short interview answer**

ARIMA adds differencing to ARMA so we can model non-stationary series. SARIMA extends ARIMA with seasonal AR, seasonal differencing, and seasonal MA terms.

**Core formulas**

```text
ARIMA(p,d,q):
Φ(B) (1 - B)^d y_t = c + Θ(B) ε_t

SARIMA(p,d,q)(P,D,Q)_s:
Φ(B) Φ_s(B^s) (1 - B)^d (1 - B^s)^D y_t
    = c + Θ(B) Θ_s(B^s) ε_t
```

Where:

- `B` is the backshift operator, so `B y_t = y_(t-1)`.
- `d` is the non-seasonal differencing order.
- `D` is the seasonal differencing order.
- `s` is the seasonal period, such as `12` for monthly data with yearly seasonality.

**How I choose between them**

- Use ARIMA if the series has trend but no clear seasonal cycle.
- Use SARIMA if the series has repeated seasonal structure.
- Confirm with seasonal plots, seasonal ACF spikes, and performance on rolling backtests.

## Q: What are exponential smoothing methods?

**Short interview answer**

Exponential smoothing forms forecasts as weighted averages of past observations, where recent observations get larger weights. Different variants model level, trend, and seasonality.

**Core formulas**

```text
Simple Exponential Smoothing:
l_t = α y_t + (1 - α) l_(t-1)
ŷ_(t+h) = l_t

Holt's Linear Trend:
l_t = α y_t + (1 - α)(l_(t-1) + b_(t-1))
b_t = β (l_t - l_(t-1)) + (1 - β) b_(t-1)
ŷ_(t+h) = l_t + h b_t

Holt-Winters Additive:
l_t = α (y_t - s_(t-m)) + (1 - α)(l_(t-1) + b_(t-1))
b_t = β (l_t - l_(t-1)) + (1 - β) b_(t-1)
s_t = γ (y_t - l_t) + (1 - γ) s_(t-m)
ŷ_(t+h) = l_t + h b_t + s_(t-m+h)
```

**Interview follow-up**

- Additive seasonality is appropriate when seasonal amplitude is roughly constant.
- Multiplicative seasonality is better when seasonal amplitude scales with the level.
- ETS is often a strong baseline because it is simple, interpretable, and fast.

## Q: When would you choose a classical model over a deep model?

**Strong answer**

- The dataset is small.
- The signal is mostly trend plus seasonality.
- Interpretability matters.
- Training and inference must be cheap and stable.
- You need a trustworthy baseline before trying more complex architectures.

**Good line to say**

I usually start with seasonal naive, ETS, ARIMA, or Prophet-like baselines, because if a complex model cannot beat them on rolling-origin backtests, it is not production-worthy yet.
