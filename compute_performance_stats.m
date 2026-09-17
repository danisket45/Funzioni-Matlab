% Questa funzione restituisce le statistiche di performance 
% partendo da una serie di rendimenti mensili.
% Le statistiche calcolate sono: CAGR, VolAnnual, Sharpe, Sortino,
% MaxDrawdown, Ulcer, Calmar.

function stats = compute_performance_stats(ret, rf)

if nargin < 2 || isempty(rf)
    rf = 0;
end

ret = ret(:);
n = length(ret);

% CAGR
cumRet = cumprod(1 + ret);
totalReturn = cumRet(end) - 1;
years = n/12;
CAGR = cumRet(end)^(1/years) - 1;

% Volatilita' annualizzata
volAnnual = std(ret) * sqrt(12);

% Sharpe (su rendimenti in eccesso rispetto al risk-free)
excess = ret - rf;
if std(excess) == 0
    Sharpe = NaN;
else
    Sharpe = mean(excess) / std(excess) * sqrt(12);
end

% Sortino (downside deviation: solo i rendimenti in eccesso negativi)
downsideDev = sqrt(mean(min(excess,0).^2)) * sqrt(12);
if downsideDev == 0
    Sortino = NaN;
else
    Sortino = (mean(excess) * 12) / downsideDev;
end

% Max drawdown
runningMax = cummax(cumRet);
drawdown = (cumRet - runningMax) ./ runningMax;
maxDD = min(drawdown); % valore negativo

% Ulcer Index
UlcerIndex = sqrt(mean(drawdown.^2));

% Calmar ratio
if maxDD == 0
    Calmar = NaN;
else
    Calmar = CAGR / abs(maxDD);
end

stats.NObs        = n;
stats.TotalReturn = totalReturn;
stats.CAGR        = CAGR;
stats.VolAnnual   = volAnnual;
stats.Sharpe      = Sharpe;
stats.Sortino     = Sortino;
stats.MaxDrawdown = maxDD;
stats.UlcerIndex  = UlcerIndex;
stats.Calmar      = Calmar;

end