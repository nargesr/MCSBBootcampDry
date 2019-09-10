load('actin_lengths.mat')
histogram(sizes)
ylabel('Number of filaments')
xlabel('Length (nm)')

figure
[f,x]=ecdf(sizes);
stairs(x,f)
xlabel('Length (nm)')
ylabel('Cumulative Probability')

%% exponentioal distribution

figure;
hold on
[f,x]=ecdf(sizes);
plot(x,f)

x = 0:140;
mu = 50;

p = exppdf(x, mu);
plot(p);

p = expcdf(x, mu);
plot(p);

legend('Origin', 'Exp pdf', 'Exp cdf');
hold off
%% Weibull distribution

figure;
hold on
[f,x]=ecdf(sizes);
plot(x,f)

x = 0:140;
a = 40;
b = 1.7;

p = wblpdf(x, a, b);
plot(p);

p = wblcdf(x, a, b);
plot(p);

legend('Origin', 'Weibull pdf', 'Weibull cdf');
hold off
%% gamma distribution

figure;
hold on
[f,x]=ecdf(sizes);
plot(x,f)

x = 0:140;
a = 4;
b = 10;

p = gampdf(x,a,b);
plot(p);

p = gamcdf(x,a,b);
plot(p);

legend('Origin', 'Gamma pdf', 'Gamma cdf');
hold off

%% Fitting Gamma, Weibull

figure;
hold on
[f,x]=ecdf(sizes);
stairs(x, f);

ab = gamfit(sizes);
xx = linspace(0, max(sizes));
plot(xx, gamcdf(xx, ab(1), ab(2)));

parmhat = wblfit(sizes);
xx = linspace(0,max(sizes));
plot(xx, wblcdf(xx, parmhat(1), parmhat(2)));

legend('Data', 'Gamma', 'Weibull');
hold off
gamsse=@(params)sumsquarederrors(@gamcdf,params,sizes);
err = gamsse([ab(1),ab(2)]);
fprintf(' The square errors of Gamma fit is %d\n', err);

gamsse=@(params)sumsquarederrors(@gamcdf,params,sizes);
err = gamsse([parmhat(1), parmhat(2)]);
fprintf(' The square errors of Weibull fit is %d\n', err);

%% Fitting Exp

res = [];
count = 1;
for i=1:length(sizes)
    if sizes(i) > 20
        res(count) = sizes(i) - 20;
        count = count + 1;
    end
end

figure;
hold on
load('actin_lengths.mat')
histogram(sizes)

multiplier = 7000;
mu = expfit(sizes);
xx = linspace(0,max(sizes));
plot(xx, multiplier * exppdf(xx, mu));

hold off
legend('Data', 'Exp');

figure;
hold on
[f,x]=ecdf([sizes zeros(1, 400)]);
stairs(x,f)
[f,x]=ecdf(res);
stairs(x,f)

mu = expfit(res);
xx = linspace(0,max(res));
plot(xx, expcdf(xx, mu));

legend('Data', 'Data norm', 'Exp');
hold off