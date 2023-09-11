# RCAC-ESC for online optimization

## SISO code

The RCAC-ESC code uses either a Kalman Filter (KF) or recursive least-squares (RLS) for gradient estimation. 

- Use 'run_RCAC_ESC_xxx_SISO.m' to run the corresponding Simulink simulation. Modify the parameters in this file to determine the total number of iterations, the initial system input, and the initial reference value
- The hyperparameters for RCAC and the gradient estimator can be modified in 'RCAC_ESC_RLS_SISO_define_opts.m'
- The Cost Function to minimize can be mnodified in 'CostFcnSISO.m'
- The perturbation (dither) function can be modified in 'PertFcnSISO.m'

## MISO code

To be added ...