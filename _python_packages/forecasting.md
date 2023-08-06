---
layout: post
title: Forecasting
nav_order: 2
---
# Time Series Classical Forecasting Methods

| Packages | Description | Downloads (pypi) |
|:--:|:--|:--:|
|  **[Statsmodels]**  | Statsmodels is one of the most popular Python packages that provides statistical computations including descriptive statistics and estimation and inference for statistical models. The time series module covers a comprehensive list of model types such as `statespace`, `ARIMA`, `VAR`, `ES`, `HMM`, etc.                                                                                 |   [![Downloads](https://static.pepy.tech/badge/statsmodels)](https://pepy.tech/project/statsmodels)   |
|    **[Prophet]**    | Prophet is a procedure for forecasting time series data based on an additive model where non-linear trends are fit with yearly, weekly, and daily seasonality, plus holiday effects. It works best with time series that have strong seasonal effects and several seasons of historical data. Prophet is robust to missing data and shifts in the trend, and typically handles outliers well. |       [![Downloads](https://static.pepy.tech/badge/prophet)](https://pepy.tech/project/prophet)       |
|     **[Orbit]**     | Orbit is a Python package for Bayesian time series forecasting and inference. It provides a familiar and intuitive initialize-fit-predict interface for time series tasks, while utilizing probabilistic programming languages under the hood.                                                                                                                                                |         [![Downloads](https://static.pepy.tech/badge/orbit)](https://pepy.tech/project/orbit)         |                                                                                                                                                                                                                                                                                                     
|   **[Pmdarima]**    | Pmdarima (originally pyramid-arima, for the anagram of 'py' + 'arima') is a statistical library for time series analysis. It has capabilities like statistical tests of stationarity and seasonality, transformers and featurizers, seasonal time series decompositions, etc.                                                                                                                 |      [![Downloads](https://static.pepy.tech/badge/pmdarima)](https://pepy.tech/project/pmdarima)      |
|     **[PyDLM]**     | PyDLM is a flexible time series modeling library for Python. This library is based on the Bayesian dynamic linear model (Harrison and West, 1999) and optimized for fast model fitting and inference.                                                                                                                                                                                         |         [![Downloads](https://static.pepy.tech/badge/pydlm)](https://pepy.tech/project/pydlm)         |
|  **[Skforecast]**   | Skforecast is a Python library that eases using scikit-learn regressors as single and multi-step forecasters. It also works with any regressor compatible with the scikit-learn API (LightGBM, XGBoost, CatBoost).                                                                                                                                                                            |    [![Downloads](https://static.pepy.tech/badge/skforecast)](https://pepy.tech/project/skforecast)    |
|    **[Sktime]**     | Sktime is a library for time series analysis in Python. It provides a unified interface for multiple time series learning tasks. Currently, this includes time series classification, regression, clustering, annotation, and forecasting. It comes with time series algorithms and scikit-learn compatible tools to build, tune and validate time series models.                             |        [![Downloads](https://static.pepy.tech/badge/sktime)](https://pepy.tech/project/sktime)        |
| **[StatsForecast]** | StatsForecast offers a collection of widely used univariate time series forecasting models, including automatic `ARIMA`, `ETS`, `CES`, and `Theta` modeling optimized for high performance using `numba`. It also includes a large battery of benchmarking models.                                                                                                                            | [![Downloads](https://static.pepy.tech/badge/statsforecast)](https://pepy.tech/project/statsforecast) |
|    **[Tslearn]**    | Tslearn is a Python package that provides machine learning tools for the analysis of time series. This package builds on (and hence depends on) scikit-learn, numpy and scipy libraries.                                                                                                                                                                                                      |       [![Downloads](https://static.pepy.tech/badge/tslearn)](https://pepy.tech/project/tslearn)       |

[Statsmodels]: https://github.com/statsmodels/statsmodels
[Prophet]: https://github.com/facebook/prophet
[Orbit]: https://github.com/uber/orbit
[Pmdarima]: https://github.com/alkaline-ml/pmdarima
[PyDLM]: https://github.com/wwrechard/pydlm
[Skforecast]: https://github.com/JoaquinAmatRodrigo/skforecast
[Sktime]: https://github.com/sktime/sktime
[StatsForecast]: https://github.com/Nixtla/statsforecast
[Tslearn]: https://github.com/tslearn-team/tslearn


# Time Series Deep Learning Forecasting Methods

| Packages | Description | Downloads (pypi) |
|:--:|:--|:--:|
|       **[GluonTS]**       |                                                                                  GluonTS is a Python package for probabilistic time series modeling, focusing on deep learning based models, based on PyTorch and MXNet.                                                                                   |             [![Downloads](https://static.pepy.tech/badge/gluonts)](https://pepy.tech/project/gluonts)             |
|    **[NeuralProphet]**    |                                   NeuralProphet is an easy to learn framework for interpretable time series forecasting. NeuralProphet is built on PyTorch and combines Neural Network and traditional time-series algorithms, inspired by Facebook Prophet and AR-Net.                                    |       [![Downloads](https://static.pepy.tech/badge/neuralprophet)](https://pepy.tech/project/neuralprophet)       |
|   **[NeuralForecast]**    |                           NeuralForecast offers a large collection of neural forecasting models focused on their usability, and robustness. The models range from classic networks like `MLP`, `RNN` to novel proven contributions like `NBEATS`, `TFT` and other architectures.                           |      [![Downloads](https://static.pepy.tech/badge/neuralforecast)](https://pepy.tech/project/neuralforecast)      |
| **[PyTorch Forecasting]** | PyTorch Forecasting is a PyTorch-based package for forecasting time series with state-of-the-art network architectures. It provides a high-level API for training networks on pandas data frames and leverages PyTorch Lightning for scalable training on (multiple) GPUs, CPUs and for automatic logging. | [![Downloads](https://static.pepy.tech/badge/pytorch-forecasting)](https://pepy.tech/project/pytorch-forecasting) |
|        **[Tsai]**         |                                                    Tsai is an open-source deep learning package built on top of Pytorch & fastai focused on state-of-the-art techniques for time series tasks like classification, regression, forecasting, imputation.                                                    |                [![Downloads](https://static.pepy.tech/badge/tsai)](https://pepy.tech/project/tsai)                |

[GluonTS]: https://github.com/awslabs/gluonts
[NeuralProphet]: https://github.com/ourownstory/neural_prophet
[NeuralForecast]: https://github.com/Nixtla/neuralforecast
[PyTorch Forecasting]: https://github.com/jdb78/pytorch-forecasting
[Tsai]: https://github.com/timeseriesAI/tsai
