function [div] = divSPD(spikeTrains1, spikeTrains2, params)
% Divergence using strictly positive definite kernels
% [div] = divSPD(spikeTrains1, spikeTrains2, params)
%
% Input:
%   spikeTrains1, spikeTrains2: (struct) sets of spike trains for comparison
%   params: (struct) see divSPDParams
% Output:
%   div: (1) divergence value
%
% div = \iint K(x,y) d\mu(y) d\mu(y)
% where \mu = (P-Q)
%
% See also: divSPDParams, divSPDParams_fgh, divCount, divL2Poisson
%
% Original idea by Memming and Sohan Seth
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

kernel = params.kernel;
% NOTE: Not all kernels are symmetric.

dxx = 0; dxy = 0; dyy = 0;
for k1 = 1:spikeTrains1.N
    for k2 = 1:spikeTrains1.N
	dxx = dxx + kernel(spikeTrains1, k1, spikeTrains1, k2);
    end
end

for k1 = 1:spikeTrains1.N
    for k2 = 1:spikeTrains2.N
	dxy = dxy + kernel(spikeTrains1, k1, spikeTrains2, k2);
    end
end

for k1 = 1:spikeTrains2.N
    for k2 = 1:spikeTrains2.N
	dyy = dyy + kernel(spikeTrains2, k1, spikeTrains2, k2);
    end
end

if spikeTrains1.N == 0 || spikeTrains2.N == 0
    div = 0;
else
    div = dxx/spikeTrains1.N^2 + dyy/spikeTrains2.N^2 ...
	- 2 * dxy/spikeTrains1.N/spikeTrains2.N;
end
