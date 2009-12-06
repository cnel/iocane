function spikeTrains = genSerialCorr(N, M, param)
% TODO: description
%
% $Id$
% Copyright 2009 Memming. All rights reserved.

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

T = param.T;
mISI = param.mISI;
urISI = param.urISI;
type = param.type;

mISI = mISI - urISI;

spikeTrains.N = N;
spikeTrains.duration = T;
spikeTrains.source = [type ' - $Id$'];
spikeTrains.subtype = type;
spikeTrains.data = cell(N, 1);
spikeTrains.samplingRate = Inf;

switch(lower(type))
case {'correlated', 'serial correlation'}
    isCorrelated = 1;
case {'renewal', 'uncorrelated'}
    isCorrelated = 0;
otherwise
    error('Unknown type: use either correlated or renewal');
end

for kM = 1:M
    for k = 1:N
	st = [0];
	if ~isCorrelated
	    while st(end) < T
		isi = mISI + rand * urISI + rand * urISI;
		st = [st; st(end) + isi];
	    end
	else
	    lastJitter = rand * urISI;
	    while st(end) < T
		currentJitter = rand * urISI;
		isi = mISI + currentJitter + lastJitter;
		lastJitter = currentJitter;
		st = [st; st(end) + isi];
	    end
	end
	st = st(2:end-1);
	spikeTrains(kM).data{k} = st;
    end
end
% vim:ts=8:sts=4:sw=4
