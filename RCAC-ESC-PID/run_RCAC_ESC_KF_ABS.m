close all
clear all
clc

k_end = 1000;
k_jump = 500;

u_init = 0;
ref_val = 5;

opts = RCAC_ESC_KF_SISO_define_opts();
Nc = opts.Nc;

%System parameters
R=0.275;
m=250;
B=0.1;
I=1.4;
%dry optimize value
u_asterix=0.9;
lambda_zero=0.2;
%ice optimize value
u_asterix_ice=0.3;
lambda_zero_ice=0.4;
lambda_zero_estimated=0.1;
% tunning parameters
%wl=0.1314;
%wc=50;
%a=0.02;
%d=42.75;
wl=0.02;
wc=100;
a=1e-1;
d=180;