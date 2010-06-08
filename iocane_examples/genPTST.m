function spikeTrains = genPTST(N, M, param)
% experiment- Precisely Timed Spike Train (PTST) vs equivalent Poisson process
% spikeTrains = genPTST(N, M, param)
%
% Input
%   N: trials per spikeTrains
%   M: number of sets of trials
%   param.T: length of the spike train
%   param.L: number of PTST events
%   param.type: 'PTST' or 'equPoisson' (equi-rate Poisson process)
%
% $Id$
% Copyright 2010 iocane project. All rights reserved.

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
%  - Redistributions of source code must retain the above copyright notice,
%    this list of conditions and the following disclaimer.
%  - Redistributions in binary form must reproduce the above copyright notice,
%    this list of conditions and the following disclaimer in the documentation
%    and/or other materials provided with the distribution.
%  - Neither the name of the iocane project nor the names of its contributors
%    may be used to endorse or promote products derived from this software
%    without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.

L = param.L; % Number of precisely timed action potentials (or bumps in Poisson case)
T = param.T; % total duration

% The mean position of APs
mu = rand(L, 1) * T/2 + T/4;
% The std of each AP
sigma = rand(L, 1) * 0.010 + 0.001;
% Probability of NOT lossing each AP
p = 1 - 0.5 * rand(L, 1);
npcum = cumsum(p); % normalized cumulative for randomly choosing one for Poisson
npcum = npcum / npcum(end);

spikeTrainsTemplate.N = N;
spikeTrainsTemplate.duration = T;
spikeTrainsTemplate.source = '$Id$';
spikeTrainsTemplate.data = cell(N, 1);
spikeTrainsTemplate.subtype = param.type;
spikeTrainsTemplate.samplingRate = Inf;

for kM = 1:M
    spikeTrains(kM) = spikeTrainsTemplate; % PTST
    switch(param.type)
    case 'PTST'
    for k = 1:N
	st = [];
	for kk = 1:L
	    if rand < p(kk)
		st = [st; randn * sigma(kk) + mu(kk)];
	    end
	end
	spikeTrains(kM).data{k} = sort(st);
    end
    case {'equPoisson', 'Poisson'}
    for k = 1:N
	st = [];
	nPoiss = poissrnd(sum(p));
	for kk = 1:nPoiss
	    kkk = find(rand < npcum, 1, 'first');
	    st = [st; randn * sigma(kkk) + mu(kkk)];
	end
	spikeTrains(kM).data{k} = sort(st);
    end
    otherwise
	error('unknown type');
    end
end

% vim:ts=8:sts=4:sw=4
