clear all
run('VLFEATROOT/toolbox/vl_setup');
addpath('/Users/gerauddaspremont/MachineLearning/AppliedML/Project1/libsvm-3.17/matlab');
Train = load('TrainSetSiftDet.mat');
Labels = load('1DimLabels.mat');
Train = double(Train(1).TrainSet);
res = double(Labels(1).res);
TrainS = 5000;

SVMstruct = svmtrain(res(1:TrainS),Train(1:TrainS,:),['-s 0 -t 1 -g 0.1']);

for i=1:300000
    name = strcat('test/','%d.png');
    Images=imread(sprintf(name,i));
    Test = siftForSmall(Images);
    Test = double(Test);
    [predict(i), accuracy,decision_values(i,:)] = svmpredict(randn,Test,SVMstruct,['-q']);
end