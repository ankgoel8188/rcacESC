function [J,y] = CostFcnSISO_line_change(k,k_jump,u,r)
    if k <=k_jump
        J = 5.*(5*u-r).^2;
        y = 5*u;
    else
        J = 5.*(2*u-r).^2;
        y = 2*u;
    end
end