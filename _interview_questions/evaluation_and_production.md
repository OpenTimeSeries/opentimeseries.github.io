---
layout: post
title: Evaluation and Production
parent: Interview Questions
nav_order: 5
---

# Evaluation and Production Interview Questions

## Q: What are the most common leakage mistakes in time-series modeling?

**Short interview answer**

Leakage happens whenever the model gets information at training time that would not be available at forecast time.

**Most common examples**

- Random train-test split instead of chronological split
- Fitting scalers or encoders on the full dataset
- Using future covariates that are unknown at prediction time
- Building target-derived rolling features with windows that cross the forecast origin
- Using revised rather than point-in-time data

**Best interview line**

For time series, leakage is often subtle because the code may look correct while the feature timestamp semantics are wrong.

## Q: How should you validate a forecasting model?

**Strong answer**

Use chronological validation, ideally rolling-origin or walk-forward backtesting.

**Example**

```text
Train: [----------]
Valid:           [---]

Train: [-------------]
Valid:                [---]
```

This better reflects how the model will actually be used in production.

## Q: How do you evaluate point forecasts?

**Common metrics**

```text
MAE  = (1/n) Σ |y_t - ŷ_t|

RMSE = sqrt( (1/n) Σ (y_t - ŷ_t)^2 )

MAPE = (100/n) Σ |(y_t - ŷ_t) / y_t|
```

**Good interview nuance**

- MAE is robust and easy to interpret.
- RMSE penalizes large errors more strongly.
- MAPE breaks when actual values are near zero.
- For intermittent demand, MAPE can be especially misleading.

## Q: How do you evaluate probabilistic forecasts and prediction intervals?

**Short interview answer**

Point metrics are not enough. I also want calibration and sharpness.

**Important metrics**

```text
Pinball loss at quantile τ:
L_τ(y, q) = max(τ(y - q), (τ - 1)(y - q))
```

Other metrics to mention:

- interval coverage
- weighted interval score
- CRPS
- quantile loss

**What interviewers like**

I want intervals that are narrow but still well calibrated. Wide intervals that cover everything are not actually useful.

## Q: How would you discuss Granger causality?

**Short interview answer**

Granger causality tests whether past values of one series improve prediction of another series beyond what the target's own history already explains.

**Regression idea**

Restricted model:

```text
y_t = a_0 + Σ a_i y_(t-i) + ε_t
```

Unrestricted model:

```text
y_t = a_0 + Σ a_i y_(t-i) + Σ b_j x_(t-j) + ε_t
```

If the unrestricted model significantly improves fit, we say `x` Granger-causes `y`.

**Important caveat**

Granger causality is about predictive usefulness, not necessarily true physical causality.

## Q: When would you choose a simpler baseline in production?

**Strong answer**

I choose the simpler model when:

- the accuracy lift from the complex model is small
- the baseline is easier to explain and maintain
- retraining latency or serving cost matters
- data drift is high and simpler models are more stable

**Good closing line**

In production, the best model is not the most sophisticated one. It is the one that wins on backtests, survives drift, and can be monitored and maintained safely.
