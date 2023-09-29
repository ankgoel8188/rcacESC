close all
clear all
clc

Tf = 1200;
Ts = 0.001;

T_samp = 10;

t_start = 20;
x0 = [1;0];

u_init = [0;0];
opts = RCAC_ESC_KF_MISO_define_opts();
Nc = opts.Nc;

options = simset('SrcWorkspace','current');
out = sim('VdP_RCAC_ESC_sim',[],options);

tt = out.tt;
xx = out.xx;
uu = out.u_RCAC;
JJ = squeeze(out.JJ);
pp = out.pert;

%%
fontLatexLabels = 18;
fontTextNotes = 18;
fontTextLabels = 18;
fontLegendLabels = 18;
fontAxisLabels = 18;

figure(1)

set(gcf, 'color', [1 1 1]) 

plot(tt, xx,'linewidth',2)

set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.FontSize = fontAxisLabels;

ylabel('$x$', 'interpreter', 'latex', 'fontsize', fontLatexLabels)
xlabel('$t$ (s)', 'interpreter', 'latex', 'fontsize', fontLatexLabels)

grid on
box on

figure(2)

set(gcf, 'color', [1 1 1]) 

plot(tt, uu,'linewidth',2)

set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.FontSize = fontAxisLabels;

ylabel('$K$', 'interpreter', 'latex', 'fontsize', fontLatexLabels)
xlabel('$t$ (s)', 'interpreter', 'latex', 'fontsize', fontLatexLabels)

grid on
box on

figure(3)

set(gcf, 'color', [1 1 1]) 

plot(tt, JJ,'linewidth',2)

set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.FontSize = fontAxisLabels;

ylabel('$J$', 'interpreter', 'latex', 'fontsize', fontLatexLabels)
xlabel('$t$ (s)', 'interpreter', 'latex', 'fontsize', fontLatexLabels)

grid on
box on

figure(4)

set(gcf, 'color', [1 1 1]) 

plot(tt, pp,'linewidth',2)

set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.FontSize = fontAxisLabels;

ylabel('$p$', 'interpreter', 'latex', 'fontsize', fontLatexLabels)
xlabel('$t$ (s)', 'interpreter', 'latex', 'fontsize', fontLatexLabels)

grid on
box on