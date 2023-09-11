function sig = PertFcnMISO(k,k_jump)
    w = pi/6;
    ph = 0;
    ph2 = 6;
    km = k;
    if k >k_jump
        %km = k-k_jump;
        km = k;
    end
    sig = 0.5*exp(-0.005*km).*[sin(w.*km + ph); sin(w.*(km-ph2) + ph)];
end