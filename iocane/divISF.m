function [div] = divISF(spikeTrains1, spikeTrains2, params)
% Integration of square distance between survival function based divergence.
% div = divICDF(spikeTrains1, spikeTrains2, params)
% 
% Input:
%   spikeTrains1, spikeTrains2: (struct) 2 sets of spike trains for comparison
% Output:
%   div: (1) divergence value
%
% Original idea from Sohan Seth
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

M1 = cellfun('length', spikeTrains1.data);
M2 = cellfun('length', spikeTrains2.data);
MM1 = spikeTrains1.N;
MM2 = spikeTrains2.N;
maxM1 = max(M1);
maxM2 = max(M2);
maxM = max(maxM1, maxM2);
histM1 = histc(M1, 0:1:maxM);
histM2 = histc(M2, 0:1:maxM);

div = zeros(maxM+1, 1);
div(end) = abs(histM1(1)/MM1 - histM2(1)/MM2);

for ki = 1:maxM
    X = zeros(histM1(ki+1), ki);
    Y = zeros(histM2(ki+1), ki);

    kList = find(M1 == ki);
    p1 = length(kList) / MM1;
    for kIdx = 1:length(kList)
	k = kList(kIdx);
	X(kIdx,:) = spikeTrains1.data{k};
    end

    kList = find(M2 == ki);
    p2 = length(kList) / MM2;
    for kIdx = 1:length(kList)
	k = kList(kIdx);
	Y(kIdx,:) = spikeTrains2.data{k};
    end

    div(ki) = sdivISF(X, Y, p1, p2);
end

div = sum(div);

% vim:ts=8:sts=4:sw=4
