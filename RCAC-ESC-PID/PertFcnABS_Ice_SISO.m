function sig = PertFcnABS_Ice_SISO(k)
    % w = pi/6;
    w = 20;
    ph = 0;
    sig = 0.02*exp(-5*k)*sin(w*k + ph); %dry 0.3 -0.5
    %sig = 0.5*sin(w*k + ph);
end