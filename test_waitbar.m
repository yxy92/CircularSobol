% test_waitbar.m



function test_waitbar(~)
D = parallel.pool.DataQueue;
afterEach(D, @nUpdateWaitbar);
h = waitbar(0,'Please wait ...');


p = 1;
N = 10^3;
parfor i = 1:N
    send(D,i);
end

close(h)
disp('Parfor loop finished')

function nUpdateWaitbar(~)
    waitbar(p/N, h);
    p = p + 1;
end


end