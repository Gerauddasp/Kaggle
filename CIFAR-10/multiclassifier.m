function [whichclass] = multiclassifier(Allstruct, Testset)

for i=1:legnth(Allstruct)
    struct = Allstruct(i);
    results(i)=Testset*struct(1).Parameters;
end

[likelihood, whichclass] = max(results);