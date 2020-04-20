function r2=fitR2mult(vx,vy)

f1=fitlm(vx,vy);
r2=f1.Rsquared.Ordinary;

end


