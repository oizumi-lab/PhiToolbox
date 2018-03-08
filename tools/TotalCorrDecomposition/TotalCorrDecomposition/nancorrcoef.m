function [ corr,p ] = nancorrcoef(data)
%Œ‡‘¹’l(nan)‚ğœ‚¢‚Ä‘ŠŠÖŒW”‚ğŒvZ‚·‚é
%function [ corr,p ] = nancorrcoef(data)
nonnan=find(~isnan(sum(data,2)));
[corr,p]=corrcoef(data(nonnan,:));