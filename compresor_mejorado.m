function y = compresor_mejorado(x,fs,threshold,ratio,attack,release)
%threshold db ataque release db ratio 
    atime = round(fs*attack/1000);
    ts = 1/fs;
    AT = 1-exp(-2.2*ts/attack/1000);
    reltime = round(fs*release/1000);
    RT = 1-exp(-2.2*ts/release/1000);
    acount = 0;
    relcount = reltime;
    xrms = seguidor_de_envolvente(x,fs);  
    dbxrms = 10*log10(xrms);
    g = 0;
    G = 0;
    for b = 1:length(x)    
        
        if dbxrms(b) > threshold
            if acount < atime
                acount = acount+1;
                G = (1-AT)*G+AT*dbxrms(b);
                g = 10^(G/20);
                y(b) = x(b)*g;
            end
            if acount >= atime
                G = ((dbxrms(b) - threshold)/ratio)+threshold-dbxrms(b);
                g = 10^(G/10);
                y(b) = g*x(b);
                relcount = 0;
            end
        end
        if dbxrms(b) < threshold
            acount = 0;
            if relcount < reltime
                %G = ((dbxrms(b) - threshold)/ratio)+threshold-dbxrms(b);
                %g = 10^(G/10);
                y(b) = g*x(b);
                relcount = relcount + 1;
            end
            if relcount >= reltime
                G = (1-RT)*G+RT*dbxrms(b);
                g = 10^(G/10);
                y(b) = x(b)*g;
            end
        end
    end
end