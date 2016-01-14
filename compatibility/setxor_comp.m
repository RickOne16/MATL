function varargout = setxor(varargin)
% Adds support for 'stable' input flag with one output
if iscell(varargin{1}) && ~iscell(varargin{2}), varargin{2} = {varargin{2}}; end
if iscell(varargin{2}) && ~iscell(varargin{1}), varargin{1} = {varargin{2}}; end
if nargin>=3 && strcmp(varargin{end},'stable')
    % This is almost like setdiff:
    if strcmp(varargin{3},'rows')
        y = [varargin{1}; varargin{2}];
        [a, ~, x] = unique(y,'rows');
        x1 = x(1:size(varargin{1},1));
        x2 = x(size(varargin{1},1)+1:end); 
    else
        y = [varargin{1}(:); varargin{2}(:)];
        [a, ~, x] = unique(y);
        x1 = x(1:numel(varargin{1}));
        x2 = x(numel(varargin{1})+1:end); 
    end
    ind = ~ismember(x1, x2);
    x = x1(ind);
    if ~isempty(x)
        x = x(~any(triu(bsxfun(@eq, x, x.'),1)));
    end
    if strcmp(varargin{3},'rows')
        y = a(x,:);
    else        
        y = a(x);
    end
    % Keep partial output:
    z = y;
    % Same with inputs reversed:
    if strcmp(varargin{3},'rows')
        y = [varargin{2}; varargin{1}];
        [a, ~, x] = unique(y,'rows');
        x2 = x(1:size(varargin{2},1));
        x1 = x(size(varargin{2},1)+1:end); 
    else
        y = [varargin{2}(:); varargin{1}(:)];
        [a, ~, x] = unique(y);
        x2 = x(1:numel(varargin{2}));
        x1 = x(numel(varargin{2})+1:end); 
    end
    ind = ~ismember(x2, x1);
    x = x2(ind);
    if ~isempty(x)
        x = x(~any(triu(bsxfun(@eq, x, x.'),1)));
    end
    if strcmp(varargin{3},'rows')
        y = a(x,:);
    else        
        y = a(x);
    end
    % Join partial outputs:
    if ~strcmp(varargin{3},'rows') && isrow(varargin{1}) && isrow(varargin{2})
        z = [z y];
    else
        z = [z; y];
    end
    varargout{1} = z;    
else
    if strcmp(varargin{end},'sorted'), varargin(end) = []; end
    varargout = cell(1,nargout);
    [varargout{:}] = builtin('setxor', varargin{:});
end
end