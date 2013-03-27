function [newmessagelength] = printProgress(previousLength,currentWork,maximumWork)
% a function which pretty prints a progress bar.
%
% input:
%   previousLength  -   length of the previous pretty print.
%   currentWork     -   current status in the amount of work (e.g. the loop
%                       variable)
%   maximumWork     -   the maximum number of steps (e.g. the end of the
%                       loop)
%
%  result:
%       newmessagelength    -   the length of the pretty pring.
%
% example use:
%
%   length = 0;
%   for i=1:5
%       // some kind of very hard work
%       length = printProgress(length,i,5)
%   end
%
% output:
%
%   progress: 20% [++++++++                                ]
%   progress: 40% [++++++++++++++++                        ]
%   progress: 60% [++++++++++++++++++++++++                ]
%   progress: 80% [++++++++++++++++++++++++++++++++        ]
%   progress: 100% [++++++++++++++++++++++++++++++++++++++++]

fprintf(repmat('\b',1,previousLength));
barlength = 40.0;

percentage= min(1,currentWork/maximumWork);
newmessagelength = 0;
newmessagelength = newmessagelength + fprintf('\rprogress: %g%% [',floor(100*percentage));

nbOfPlusses = floor(barlength*percentage);
nbOfSpaces = barlength-nbOfPlusses;

fprintf(repmat('+',1,nbOfPlusses));
fprintf(repmat(' ',1,nbOfSpaces));
fprintf(']\n');
newmessagelength=newmessagelength+barlength+2;

end

