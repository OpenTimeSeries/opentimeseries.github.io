---
layout: post
title: Multivariate and Deep Learning
parent: Interview Questions
nav_order: 4
---

# Multivariate and Deep Learning Interview Questions

## Q: How do you model multivariate time series?

**Short interview answer**

If the variables influence each other, I need a model that captures cross-series dependence, not just separate univariate forecasts.

**Classical choices**

- VAR for stationary multivariate dependence
- VARMAX when exogenous variables are present
- VECM when the series are cointegrated
- State-space models for latent-dynamics formulations

**VAR formula**

```text
y_t = c + A_1 y_(t-1) + A_2 y_(t-2) + ... + A_p y_(t-p) + ε_t
```

Where:

- `y_t` is now a vector
- each `A_i` is a coefficient matrix
- `ε_t` is a multivariate innovation term

## Q: What is cointegration, and when do you use VECM?

**Short interview answer**

Cointegration means several non-stationary series move together so that some linear combination of them is stationary. In that case, differencing everything with a plain VAR can lose long-run equilibrium structure, so VECM is more appropriate.

**Core idea**

If `x_t` and `z_t` are each `I(1)` but:

```text
u_t = x_t - β z_t
```

is stationary, then they are cointegrated.

**VECM form**

```text
Δ y_t = Π y_(t-1) + Σ_(i=1 to p-1) Γ_i Δ y_(t-i) + ε_t
```

The matrix `Π` captures long-run equilibrium adjustment.

## Q: Explain the vanishing gradient problem in RNNs.

**Short interview answer**

In backpropagation through time, gradients are repeatedly multiplied by Jacobian terms. If those terms have magnitude smaller than one, the gradient shrinks exponentially as we move backward in time.

**Simple intuition**

```text
∂L/∂h_t = ∂L/∂h_T × Π_(k=t+1 to T) ∂h_k/∂h_(k-1)
```

If many factors in that product are small, early states receive almost no learning signal.

## Q: How does LSTM address this problem?

**Short interview answer**

LSTM introduces a cell state and gating so the network can preserve information through additive updates rather than only repeated multiplicative shrinkage.

**Core equations**

```text
f_t = σ(W_f [h_(t-1), x_t] + b_f)
i_t = σ(W_i [h_(t-1), x_t] + b_i)
o_t = σ(W_o [h_(t-1), x_t] + b_o)
g_t = tanh(W_g [h_(t-1), x_t] + b_g)

c_t = f_t ⊙ c_(t-1) + i_t ⊙ g_t
h_t = o_t ⊙ tanh(c_t)
```

**What to say in interviews**

- The forget gate controls memory retention.
- The input gate controls how much new information is written.
- The output gate controls exposure of the hidden state.

## Q: What are time-series foundation models, and how are they different from training from scratch?

**Strong answer**

Time-series foundation models are pre-trained on many datasets or tasks and then adapted or used zero-shot on new series.

**Good comparison**

- Training from scratch learns only from one task or one dataset.
- Foundation models start with reusable representations and may transfer better across domains.
- They are most attractive when labeled data is limited or when you need strong cold-start baselines.

**Examples to mention**

- Chronos
- TimesFM
- MOMENT
- MOIRAI
- TimeGPT

## Q: What is zero-shot forecasting, and when would you trust it?

**Strong answer**

Zero-shot forecasting means applying a pre-trained model to a new series without task-specific fine-tuning.

I trust it more when:

- the target domain resembles the pretraining distribution
- the forecast horizon is moderate
- backtests on a holdout slice are stable
- it beats simple baselines such as seasonal naive and AutoARIMA

I do not trust it blindly in highly regulated, sparse, or distribution-shifted settings without backtesting.
