function [ txt ] = PrintPartitions( AllPartitions )
txt = @(x) [ '[ ', repmat( '%d ', 1, numel(x) ), ']' ];
txtpartition = @( part ) cell2mat( cellfun( @(x) sprintf( txt( x ), x ), part, 'UniformOutput', false ) );
if nargout < 1
    cellfun( @(x) fprintf( '%s\n', txtpartition(x) ), AllPartitions );
else
    txt = cellfun( @(x) sprintf( '%s', txtpartition(x) ), AllPartitions, 'UniformOutput', false );
end


end
