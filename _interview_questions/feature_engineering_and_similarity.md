---
layout: post
title: Feature Engineering and Similarity
parent: Interview Questions
nav_order: 3
---

# Feature Engineering and Similarity Interview Questions

## Q: What feature engineering techniques are common in time series?

**Short interview answer**

I usually group them into lag features, rolling statistics, seasonal calendar features, transformations, and external covariates.

**Common feature groups**

- Lags: `y_(t-1), y_(t-7), y_(t-24)`
- Rolling stats: mean, std, min, max, quantiles
- Differences and growth rates
- Calendar features: hour, day of week, month, holiday, promotion
- Expanding-window features
- Spectral or frequency-domain summaries

**Typical formulas**

```text
Lag-k feature:
x_t^(lag,k) = y_(t-k)

Rolling mean over window w:
m_t = (1 / w) Σ_(i=1 to w) y_(t-i)

Rolling variance:
s_t^2 = (1 / (w-1)) Σ_(i=1 to w) (y_(t-i) - m_t)^2
```

## Q: How do you transform time-series data?

**Short interview answer**

Transformations can stabilize variance, improve stationarity, reduce skew, or make optimization easier.

**Important formulas**

```text
Log transform:
z_t = log(y_t)

Box-Cox transform:
z_t = (y_t^λ - 1) / λ      if λ ≠ 0
z_t = log(y_t)             if λ = 0

Z-score scaling:
z_t = (y_t - μ) / σ

Min-max scaling:
z_t = (y_t - y_min) / (y_max - y_min)
```

**Production caveat**

Fit scaling parameters only on the training period. Fitting on the full series causes leakage.

## Q: How do you measure similarity between two time series?

**Strong answer**

The choice depends on whether timing shifts should count as mismatch.

**Key options**

- Euclidean distance if the sequences are aligned and same length.
- Dynamic Time Warping if local time shifts should be tolerated.
- Correlation if shape matters more than scale.
- Cosine similarity if direction matters more than magnitude.

**Important formulas**

```text
Euclidean distance:
d(x, y) = sqrt( Σ_i (x_i - y_i)^2 )

Cosine similarity:
cos(x, y) = (x · y) / (||x|| ||y||)

Pearson correlation:
ρ(x, y) = Cov(x, y) / (σ_x σ_y)
```

**DTW intuition**

DTW solves a dynamic-programming problem that finds the minimum-cost alignment path between two sequences, allowing local stretching and compression in time.

## Q: How would you handle missing values in time series?

**Strong answer**

I first ask whether the missingness is informative. In operations or IoT systems, missingness may itself indicate failure or downtime.

**Typical methods**

- Forward fill or backward fill
- Linear interpolation
- Seasonal interpolation
- Model-based imputation
- Missingness indicator features

**What interviewers like to hear**

- Do not impute using future information if the prediction setting is causal.
- Evaluate the imputation method inside the training pipeline, not on the full dataset.
- For long missing spans, naive interpolation may hallucinate false structure.
