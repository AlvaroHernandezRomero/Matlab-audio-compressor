function xrms = seguidor_de_envolvente(x,fs)
ts = 1/fs;
tm = 512/fs;
Tav = 1-exp(-2.2*ts/tm);

xrms = x*0;
for i = 1:length(x)
    if i == 1
        xrms(i) = Tav*x(i)^2;
    else
        xrms(i) = (1-Tav)*xrms(i-1) + Tav*x(i)^2;
    end
end