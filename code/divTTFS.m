function [div] = divTTFS(spikeTrains1, spikeTrains2, params)
% Divergence between the estimated time to first spike (TTFS) distributions
% div = divTTFS(spikeTrains1, spikeTrains2, params)
%
% The statistic is the time of the first spike in each spike train.
% If the spike train has no spikes, the first time is set to twice the duration
% 
% Input:
%   spikeTrains1, spikeTrains2: (struct) 2 sets of spike trains for comparison
%   params: (struct) see divTTFSParams
% Output:
%   div: (1) divergence value
%
% See also: divTTFSParams
%
% $Id$
% Copyright 2009 iocane project. All rights reserved.

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

ttfs1 = zeros(spikeTrains1.N, 1);
for k = 1:spikeTrains1.N
    st = spikeTrains1.data{k};
    if isempty(st)
	ttfs1(k) = spikeTrains1.duration * 2;
    else
	ttfs1(k) = st(1);
    end
end

ttfs2 = zeros(spikeTrains2.N, 1);
for k = 1:spikeTrains2.N
    st = spikeTrains2.data{k};
    if isempty(st)
	ttfs2(k) = spikeTrains2.duration * 2;
    else
	ttfs2(k) = st(1);
    end
end

div = params.subDiv(ttfs1, ttfs2, params.subDivParams);
% vim:ts=8:sts=4:sw=4
