# Source code for Alternating minimization for square root principal component pursuit

This directory contains the source code for the Alternating minimization methods proposed in the paper "Alternating minimization for square root principal component pursuit" for solving the square root Principal Component Pursuit (srPCP) problem.

## Files Overview

| File Name | Description |
|-----------|-------------|
| `AltMin.m` | Main function implementing the alternating minimization (`AltMin`) algorithm and its acceleration method (`Acc_AltMin`) for srPCP |
| `UpdateL.m` | Function for updating the low-rank matrix L |
| `UpdateS.m` | Function for updating the sparse matrix S |
| `UpdateS_sub.m` | Solver for the subproblem in updating S and L components |

## Problem Formulation

This code solves the square root Principal Component Pursuit problem:

$$\min_{L,S} \|L\|_* + \lambda \|S\|_1 + \mu \|L+S-D\|_F$$

where:
- $\|L\|_*$ is the nuclear norm of matrix $L$
- $\|S\|_1$ is the $\ell_1$-norm of matrix $S$
- $\|L+S-D\|_F$ is the Frobenius norm of the reconstruction error
- $D$ is the observed matrix
- $\lambda$ and $\mu$ are penalty parameters

## Detailed File Descriptions

### AltMin.m

Main function implementing the alternating minimization (AltMin) algorithm and its acceleration method (Acc_AltMin) for srPCP. This function solves the srPCP problem using an alternating minimization approach by iteratively updating the low-rank matrix $L$ and the sparse matrix $S$.

#### Function Signature
```matlab
[L, S, obj, iter, runhist] = AltMin(D, lambda, mu, options)
```

#### Input Parameters
- **D**: Input $n_1\times n_2$ matrix (assumed $n_1 \geq n_2$, will be transposed if not)
- **lambda**: Positive penalty parameter for the $\ell_1$-norm of $S$
- **mu**: Positive penalty parameter for the Frobenius norm term
- **options**: Optional parameter structure with the following fields:
  - `tol`: Convergence tolerance (default: 1e-6)
  - `printyes`: Whether to print iteration information (default: 1)
  - `maxiter`: Maximum number of iterations (default: 1000)
  - `maxtime`: Maximum running time in seconds (default: 3600*5 = 18000)
  - `L_rank`: Initial rank guess for $L$ (default: int64(n2/1000)+1)
  - `update_method`: Method for updating $L$ (`base` or `overparametrized`, default: `base`). Setting  `update_method = overparametrized` can  use the `Acc_AltMin` method in the paper.

#### Output Parameters
- **L**: Recovered low-rank matrix
- **S**: Recovered sparse matrix
- **obj**: Final objective function value
- **iter**: Number of iterations performed
- **runhist**: Structure recording iteration history with the following fields:
  - `obj`: Objective function values at each iteration
  - `ttime`: Cumulative running time at each iteration
  - `L_rank`: Rank of L at each iteration
  - `S_nnz`: Number of non-zero elements in S at each iteration
  - `sorting_time`: Cumulative time spent on sorting operations
  - `svd_time`: Cumulative time spent on SVD operations
  - `eta`: Convergence metric computed as the normalized difference between S and its proximal operator
  - `succ`: Maximum of successive changes in objective, L, and S
  - `iter`: Total number of iterations performed

### UpdateL.m

This function provides implementations for updating the low-rank matrix $L$. It supports two update methods:

1. **Base Method**: Uses SVD decomposition and the UpdateS_sub function to update $L$
2. **Overparametrized Method**: Employs incremental rank estimation and acceleration techniques to achieve potentially faster convergence, as embodied by the `Acc_AltMin` algorithm in the paper.

**Usage:**
```matlab
[L, L_nuc_norm, L_rank] = UpdateL(A, lambda, option_L);
```

### UpdateS.m

This function updates the sparse matrix $S$ by solving a vector-wise optimization problem. It converts the matrix to a vector, applies the soft-thresholding operation, and then reshapes the result back to a matrix.

**Usage:**
```matlab
S = UpdateS(A, lambda);
```

### UpdateS_sub.m

This function solves the subproblem for updating both $S$ and $L$ components. It efficiently computes the optimal solution to the vector optimization problem:

$$\min_s \|s-a\|_2 + \lambda \|s\|_1$$


**Usage:**
```matlab
[normdiff, k, s] = UpdateS_sub(a, lambda);
```


## Examples of Using Different Options

The `AltMin` function supports various options that can be adjusted to control its behavior, especially the overparameterization features. Below are examples demonstrating how to use different options with the `AltMin` function.

### Example 1: Basic Usage with Default Options

```matlab
% Generate a sample low-rank plus sparse matrix
n1 = 1000;
n2 = n1;
% sparse S
prob_S = 0.1; 
max_S = 0.05; 
rng(1);
S = (rand(n1,n2)<prob_S).*(2*(rand(n1,n2)<0.5)-1)*max_S;
% low rank L
r = 50;
U = randn(n1,r)/sqrt(n1);
V = randn(n2,r)/sqrt(n2);
L = U*V';
% noise
sigma = 1e-3;
Z = sigma*randn(n1,n2);
% D
D = L +S+ Z; 


% Set parameters
lambda = 1/sqrt(n1); % Standard choice for lambda
mu = sqrt(n2/2); % Standard choice for mu

% Default options (empty structure)
options = [];

% Run AltMin with default options
[L_rec, S_rec, obj, iter, runhist] = AltMin(D, lambda, mu, options);
```

### Example 2: Using Overparametrized Method

```matlab
% Create options structure with overparametrized method
options = [];
options.update_method = 'overparametrized'; % Use overparametrized method

% Run AltMin with overparametrized method
[L_rec, S_rec, obj, iter, runhist] = AltMin(D, lambda, mu, options);
```



### Example 3: Custom Convergence Criteria

```matlab
% Create options with custom convergence criteria
options = [];
options.tol = 1e-4; % Looser tolerance (faster convergence)
options.maxiter = 500; % Maximum number of iterations
options.printyes = 0; % Disable printing

% Run AltMin with custom criteria
[L_rec, S_rec, obj, iter, runhist] = AltMin(D, lambda, mu, options);
```

### Example 4: Overparametrized Method with High Initial Rank Guess

```matlab
% Create options with a high initial rank guess
options = [];
options.update_method = 'overparametrized';
options.L_rank = 50; % Higher initial rank guess

% Run AltMin with high initial rank
[L_rec, S_rec, obj, iter, runhist] = AltMin(D, lambda, mu, options);
```

### Available Options Summary

| Option | Description | Default Value |
|--------|-------------|---------------|
| `tol` | Convergence tolerance | `1e-6` |
| `printyes` | Whether to print iteration information | `true` |
| `maxiter` | Maximum number of iterations | `1000` |
| `maxtime` | Maximum allowed computation time (seconds) | `3600*5` (5 hours) |
| `update_method` | Method for updating L (`'base'` or `'overparametrized'`) | `'base'` |
| `L_rank` | Initial rank guess for overparametrized method | `int64(n2 / 1000) + 1` |
