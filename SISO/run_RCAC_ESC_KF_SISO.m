close all
clear all
clc

k_end = 1000;
k_jump = 500;

u_init = 0;
ref_val = 5;

opts = RCAC_ESC_KF_SISO_define_opts();
Nc = opts.Nc;

options = simset('SrcWorkspace','current');
out = sim('RCAC_ESC_KF_SISO',[],options);

fontLatexLabels = 18;
fontTextNotes = 18;
fontTextLabels = 18;
fontLegendLabels = 18;
fontAxisLabels = 18;

figure(1)

set(gcf, 'color', [1 1 1]) 

plot(out.tt, out.u,'linewidth',2)
hold on
plot(out.tt, out.ref, 'k--','linewidth',2)
hold off

legend({'$u$','$r$'},'interpreter','latex','fontsize', fontLegendLabels);

set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.FontSize = fontAxisLabels;

ylabel('$u$', 'interpreter', 'latex', 'fontsize', fontLatexLabels)
xlabel('$k$ (step)', 'interpreter', 'latex', 'fontsize', fontLatexLabels)

grid on
box on

figure(2)

set(gcf, 'color', [1 1 1]) 

plot(out.tt, out.pert,'linewidth',2)

set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.FontSize = fontAxisLabels;

ylabel('$\Delta u$', 'interpreter', 'latex', 'fontsize', fontLatexLabels)
xlabel('$k$ (step)', 'interpreter', 'latex', 'fontsize', fontLatexLabels)

grid on
box on