function sig = PertFcnSISO(k)
    % w = pi/6;
    w = 6;
    ph = 0;
    sig = 0.02*exp(-0.05*k)*sin(w*k + ph); %dry 0.3 -0.5
    %sig = 0.5*sin(w*k + ph);
end