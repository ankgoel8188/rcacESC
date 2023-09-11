function J = CostFcnMISO(u,r)
    %J = sum(abs(u-r));
    J = 1000*sum((u-r).^2);
end