%read data from simlation

[f,a,p] = textread('C:\Documents and Settings\Bruce Land\My Documents\WebSites\ece576\DDA\AnalogSimNiosII\SimData2.txt',...
    'freq=%f, amp=%f, phase=%f')

[f,i] = sort(f);
a = a(i);
p = p(i);
figure(1), clf;

subplot(2,1,1)
semilogy(log10(f),a,'bo','markersize',4)
line([log10(485) log10(485)], [100,1],'color','red')
title('Second order system:')
set(gca,'xticklabel',num2str(10.^(str2num(get(gca,'xticklabel'))),'%3.0f'));
hold on
aa = 1./sqrt((1-f.^2/485^2).^2 + (1/32*f/485).^2);
semilogy(log10(f),aa,'r' )

subplot(2,1,2)
plot(log10(f),-p,'bo','markersize',4)
line([log10(485) log10(485)], [-100,-1],'color','red')
set(gca,'xticklabel',num2str(10.^(str2num(get(gca,'xticklabel'))),'%3.0f'));
xlabel('log10(frequency)')
hold on
plot(log10(f),-atan2((1/32*f/485),(1-f.^2/485^2))*57.3,'r')