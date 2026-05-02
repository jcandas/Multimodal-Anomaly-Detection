function testsliceColor = imagesatdata(data,position);


testsliceR = squeeze(data(:,:, position,3)) / 1300;
testsliceG = squeeze(data(:,:, position,2)) / 1300;
testsliceB = squeeze(data(:,:, position,1)) / 1300;

testsliceR(testsliceR > 1) = nan;
testsliceG(testsliceG > 1) = nan;
testsliceB(testsliceB > 1) = nan;

testsliceColor(:,:,1) = testsliceR;
testsliceColor(:,:,2) = testsliceG;
testsliceColor(:,:,3) = testsliceB;

