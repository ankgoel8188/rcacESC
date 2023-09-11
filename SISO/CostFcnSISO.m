function J = CostFcnSISO(u,r)
    %J = abs(u-r);
    J = 10*(u-r).^2;
end