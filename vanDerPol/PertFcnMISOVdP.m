function sig = PertFcnMISOVdP(tt, T_samp, t_start)
    w = pi/6;
    ph = 0;
    ph2 = 6;
    if (tt >= t_start)
        km = floor(tt/T_samp);
        sig = 0.5*exp(-0.25*km).*[sin(w.*km + ph); sin(w.*(km-ph2) + ph)];
    else
        sig = [0;0];
    end
end