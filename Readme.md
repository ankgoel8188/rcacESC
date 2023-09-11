# RCAC-ESC for online optimization

The RCAC-ESC code uses either a Kalman Filter (KF) or recursive least-squares (RLS) for gradient estimation. 

## SISO code

- Use 'run_RCAC_ESC_xxx_SISO.m', using either KF or RLS, to run the corresponding Simulink simulation. Modify the parameters in this file to determine the total number of iterations, the iteration at which the reference value changes, the initial system input, and the initial reference value.
- The hyperparameters for RCAC and the gradient estimator can be modified in 'RCAC_ESC_xxx_SISO_define_opts.m', using either KF or RLS.
- The Cost Function to minimize can be mnodified in 'CostFcnSISO.m'.
- The perturbation (dither) function can be modified in 'PertFcnSISO.m'.

## SISO code for line change scenario

Similar to SISO code, applied to a system in which the system changes at a particular iteration (line slope changes).

## MISO code

- Use 'run_RCAC_ESC_xxx_MISO.m', using either KF or RLS, to run the corresponding Simulink simulation. Modify the parameters in this file to determine the total number of iterations, the iteration at which the reference value changes, the initial system input, and the reference values.
- The hyperparameters for RCAC and the gradient estimator can be modified in 'RCAC_ESC_xxx_MISO_define_opts.m', using either KF or RLS.
- The Cost Function to minimize can be mnodified in 'CostFcnMISO.m'.
- The perturbation (dither) function can be modified in 'PertFcnMISO.m'.
