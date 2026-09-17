% Questa funzione crea un portafoglio buy-and-hold con pesi target fissi, 
% lasciati derivare naturalmente mese per mese e riportati
% al target solo ogni 12 mesi
%
% PortfolioReturns_BH : T x 1, rendimento mensile realizzato
% WeightsOverTime     : T x N, pesi effettivi (post-drift) ad ogni mese,
%                       utile per verificare quanto si allontanano dal
%                       target tra un ribilanciamento e l'altro

function [PortfolioReturns_BH, WeightsOverTime] = simulate_buyhold_periodic_rebalance(Returns, w_target, rebalanceFreq)

w_target = w_target(:)';
w_target = w_target / sum(w_target); % normalizzazione

T = size(Returns,1);
N = size(Returns,2);

PortfolioReturns_BH = nan(T,1);
WeightsOverTime = nan(T,N);

w_current = w_target;

for t = 1:T

    if any(isnan(Returns(t,:)))
        PortfolioReturns_BH(t) = NaN;
        continue
    end

    r_t = Returns(t,:);
    portRet = sum(w_current .* r_t);

    PortfolioReturns_BH(t) = portRet;

    % drift naturale dei pesi in base al rendimento relativo di ciascuna
    % asset class rispetto al portafoglio nel suo complesso
    w_current = w_current .* (1 + r_t) / (1 + portRet);

    WeightsOverTime(t,:) = w_current;

    % ribilanciamento periodico: si torna al target solo ogni rebalanceFreq mesi
    if mod(t, rebalanceFreq) == 0
        w_current = w_target;
    end

end

end