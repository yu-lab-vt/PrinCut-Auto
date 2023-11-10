function [t_mu, t_sigma, varCorrectionTerm] = truncatedGauss(mu, sigma, lower, upper)
% given a truncated gaussian, get its mu and sigma

alpha = (lower-mu) / sigma;
beta = (upper-mu) / sigma;

Z = normcdf(beta) - normcdf(alpha);

a_pdf = normpdf(alpha, 0, 1);
b_pdf = normpdf(beta, 0, 1);

t_mu = mu + (a_pdf-b_pdf)*sigma/Z;

if isinf(alpha)
    alpha = -1e7;
end
if isinf(beta)
    beta = 1e7;
end
t1 = (alpha*a_pdf-beta*b_pdf) / Z;
t2 = ((a_pdf - b_pdf) / Z)^2;
varCorrectionTerm = 1+t1-t2;
t_sigma = sigma*sqrt(varCorrectionTerm);
end