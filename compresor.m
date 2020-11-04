function y = compresor(x,fs,threshold,ratio,attack,release)

    %threshold db ataque release db ratio 
    atime = round(fs*attack/1000);
    reltime = round(fs*release/1000);
    acount = 0;
    relcount = reltime;
    xrms = seguidor_de_envolvente(x,fs);  
    dbxrms = 10*log10(xrms);
    for b = 1:length(x)    
        if dbxrms(b) > threshold
            if acount < atime
                acount = acount+1;
                y(b) = x(b);
            end
            if acount >= atime
                G = ((dbxrms(b) - threshold)/ratio)+threshold-dbxrms(b);
                g = 10^(G/20);
                y(b) = g*x(b);
                relcount = 0;
            end
        end
        if dbxrms(b) < threshold
            acount = 0;
            if relcount < reltime
                y(b) = g*x(b);
                relcount = relcount + 1;
            end
            if relcount >= reltime
                y(b) = x(b);
            end
        end
    end
    
