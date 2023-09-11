function sig = PertFcnSISO(k)
    w = pi/6;
    ph = 0;
    sig = 0.5*exp(-0.5*k)*sin(w*k + ph);
    %sig = 0.5*sin(w*k + ph);
end