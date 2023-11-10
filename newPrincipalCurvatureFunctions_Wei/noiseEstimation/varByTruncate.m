function sigma2 = varByTruncate(vals, numSigma, numIter)
% given a set of normal-like values, truncate it to estimate the variance
% in case there are outliers
% TODO: currently only process cases with mean equals to 0
if true % consider mean
    sigma = std(vals);
    mu = mean(vals);
    for i=1:numIter
        ub = mu+numSigma*sigma;
        lb = mu-numSigma*sigma;
        tmpVals = vals(vals<ub & vals>lb);
        sigmaTr = std(tmpVals);
        %sigmaTr = sqrt(mean(vals(vals<ub & vals>lb).^2));
        [~, ~, varCorrectionTerm] = truncatedGauss(mu, sigma, lb, ub); % only lb and ub is usefull if we only want the third output
        sigma = sigmaTr./sqrt(varCorrectionTerm);
        mu = mean(tmpVals);
    end
else % force mean to be 0
    sigma = sqrt(mean(vals.^2));
    %sigma = std(vals);
    for i=1:numIter
        mu = 0;
        ub = mu+numSigma*sigma;
        lb = mu-numSigma*sigma;
        %tmpVals = vals(vals<ub & vals>lb);
        %sigmaTr = std(tmpVals);
        sigmaTr = sqrt(mean(vals(vals<ub & vals>lb).^2));
        [~, ~, varCorrectionTerm] = truncatedGauss(mu, sigma, lb, ub); % only lb and ub is usefull if we only want the third output
        sigma = sigmaTr./sqrt(varCorrectionTerm);
    end
end
sigma2 = sigma^2;
end