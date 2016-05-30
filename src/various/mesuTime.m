% Copyright or © or Copr. Luc LAURENT (30/06/2016)
% luc.laurent@lecnam.net
% 
% This software is a computer program whose purpose is to generate sampling
% using dedicated techniques.
% 
% This software is governed by the CeCILL license under French law and
% abiding by the rules of distribution of free software.  You can  use, 
% modify and/ or redistribute the software under the terms of the CeCILL
% license as circulated by CEA, CNRS and INRIA at the following URL
% "http://www.cecill.info". 
% 
% As a counterpart to the access to the source code and  rights to copy,
% modify and redistribute granted by the license, users are provided only
% with a limited warranty  and the software's author,  the holder of the
% economic rights,  and the successive licensors  have only  limited
% liability. 
% 
% In this respect, the user's attention is drawn to the risks associated
% with loading,  using,  modifying and/or developing or reproducing the
% software by the user in light of its specific status of free software,
% that may mean  that it is complicated to manipulate,  and  that  also
% therefore means  that it is reserved for developers  and  experienced
% professionals having in-depth computer knowledge. Users are therefore
% encouraged to load and test the software's suitability as regards their
% requirements in conditions enabling the security of their systems and/or 
% data to be ensured and,  more generally, to use and operate it in the 
% same conditions as regards security. 
% 
% The fact that you are presently reading this means that you have had
% knowledge of the CeCILL license and that you accept its terms.

%% Script dedicated to the initiailisation, the measure and the display of the spent time
%% L.LAURENT -- 15/05/2012 -- luc.laurent@lecnam.net

function [tictoc_compt,tInit]=mesuTime(compteur,tps_init)

if nargin==0
    %initialization tic-toc count
    tictoc_compt=tic;
    %Measure initial CPU time
    tInit=cputime;
    
elseif nargin==2
    tElapsed=toc(compteur);
    tCPUElapsed=cputime-tps_init;
    fprintf(' - - - - - - - - - - - - - - - - - - - - \n')
    fprintf('  #### Time/CPU time (s): %4.2f s / %4.2f s\n',tElapsed,tCPUElapsed);
end
