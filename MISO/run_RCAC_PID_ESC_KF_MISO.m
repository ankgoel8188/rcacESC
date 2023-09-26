close all
clear all
clc

k_end = 10000;
k_jump = 3000;

u_init = [0;0];
ref_val_1 = [5; 5];
ref_val_2 = [10; 0];

opts = RCAC_PID_ESC_KF_MISO_define_opts();
Nc_max = max(abs(opts.PID_flag(:)));

options = simset('SrcWorkspace','current');
out = sim('RCAC_PID_ESC_KF_MISO',[],options);

fontLatexLabels = 18;
fontTextNotes = 18;
fontTextLabels = 18;
fontLegendLabels = 18;
fontAxisLabels = 18;

figure(1)

set(gcf, 'color', [1 1 1]) 

plot(out.tt, out.pert,'linewidth',2)

set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.FontSize = fontAxisLabels;

ylabel('$\Delta u$', 'interpreter', 'latex', 'fontsize', fontLatexLabels)
xlabel('$k$ (step)', 'interpreter', 'latex', 'fontsize', fontLatexLabels)

grid on
box on

figure(2)

set(gcf, 'color', [1 1 1]) 

plot(out.tt, out.u,'linewidth',2)
hold on
plot(out.tt, out.ref, '--','linewidth',2)
hold off

legend({'$u_1$','$u_2$','$r_1$','$r_2$'},'interpreter','latex','fontsize', fontLegendLabels);

set(gca,'TickLabelInterpreter','latex')
ax = gca;
ax.FontSize = fontAxisLabels;

ylabel('$u$', 'interpreter', 'latex', 'fontsize', fontLatexLabels)
xlabel('$k$ (step)', 'interpreter', 'latex', 'fontsize', fontLatexLabels)

grid on
box on

