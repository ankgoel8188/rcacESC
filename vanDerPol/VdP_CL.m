close all
clear all
clc

Tf = 50;
Ts = 0.001;

t_start = 20;
x0 = [1;0];
Kc = [-2 -5];

options = simset('SrcWorkspace','current');
out = sim('VdP_CL_sim',[],options);

tt = out.tt;
xx = out.xx;

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
xlabel('$k$ (step)', 'interpreter', 'latex', 'fontsize', fontLatexLabels)

grid on
box on