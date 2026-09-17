% Questa funzione calcola i pesi del portafoglio a varianza minima 
% di Markowitz su una finestra di rendimenti.

function w = markowitz_min_variance_weights(returns_window, lb, ub)

N = size(returns_window,2);

Sigma = cov(returns_window);
H = 2*Sigma; % quadprog minimizza 0.5*w'*H*w + f'*w
f = zeros(N,1);

Aeq = ones(1,N);
beq = 1;

if isempty(lb)
    lb = zeros(N,1); % no short selling
end
if isempty(ub)
    ub = ones(N,1);  % nessun vincolo superiore oltre a sum=1
end

options = optimoptions('quadprog','Display','off');

[w, ~, exitflag] = quadprog(H, f, [], [], Aeq, beq, lb, ub, [], options);

if exitflag ~= 1
    warning('markowitz_min_variance_weights:infeasible', ...
        'Ottimizzazione Markowitz non riuscita per questa finestra (verifica vincoli o singolarita'' della covarianza).');
    w = nan(N,1);
end

end